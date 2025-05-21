import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Technician/Home/FirstScreenOfBottomnavbar.dart';
import 'package:servix/Technician/Home/Home%20Layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../AI/SERVICE.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class ChatScreenTechnician extends StatefulWidget {
  const ChatScreenTechnician({super.key});

  @override
  State<ChatScreenTechnician> createState() => _ChatScreenTechnicianState();
}

class _ChatScreenTechnicianState extends State<ChatScreenTechnician> {
  ChatUser? _technician;
  final ChatUser _bot = ChatUser(id: '3', firstName: 'Gemini');
  final GeminiService _geminiService = GeminiService();
  List<ChatMessage> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadTechnicianData();
    if (_technician != null) {
      await _loadChatHistory();
    }
  }

  Future<void> _loadTechnicianData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('technician') // Fetch from "technicians" collection
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _technician = ChatUser(
            id: firebaseUser.uid,
            firstName: userData['first_name'] ?? 'Technician',
          );
        });
      }
    }
  }

  Future<void> _saveChatHistory() async {
    if (_technician == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatData = messages
        .map((msg) => jsonEncode({
              'text': msg.text,
              'userId': msg.user.id,
              'createdAt': msg.createdAt.toIso8601String(),
            }))
        .toList();
    await prefs.setStringList(
        'chat_history_technician${_technician!.id}', chatData);
  }

  Future<void> _loadChatHistory() async {
    if (_technician == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Loading chat history for technician: ${_technician!.id}");
    List<String>? chatData =
        prefs.getStringList('chat_history_technician${_technician!.id}');

    if (chatData != null && _technician != null) {
      setState(() {
        messages = chatData.map((data) {
          Map<String, dynamic> json = jsonDecode(data);
          return ChatMessage(
            text: json['text'],
            user: json['userId'] == _technician!.id ? _technician! : _bot,
            createdAt: DateTime.parse(json['createdAt']),
          );
        }).toList();
      });
    }
  }

  void onSend(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
      isLoading = true;
      messages.insert(
        0,
        ChatMessage(
          text: "Typing...".tr(),
          user: _bot,
          createdAt: DateTime.now(),
        ),
      );
    });
    _saveChatHistory();

    String aiResponse = await _geminiService.sendMessage(message.text);

    // Remove "Typing..." message before inserting real response
    setState(() {
      messages.removeAt(0); // remove the "Typing..." message
      messages.insert(
        0,
        ChatMessage(
          text: aiResponse,
          user: _bot,
          createdAt: DateTime.now(),
        ),
      );
      isLoading = false;
    });

    _saveChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_technician == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: ApplicationColor,
          ),
        ),
      );
    }

    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeTechnicianLayout()),
            (route) => false,
          );
          return false; // prevent default back navigation
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeProvider.themeMode == ThemeMode.dark
                ? const Color(0xFF333739)
                : Colors.white,
            title: Text(
              "Ai Chat".tr(),
              style: GoogleFonts.castoro(
                fontWeight: FontWeight.w500,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? const Color(0xFF333739)
                    : Colors.white,
                icon: Icon(
                  Icons.more_vert,
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onSelected: (String value) async {
                  if (value == 'Delete') {
                    setState(() {
                      messages.clear();
                    });
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs
                        .remove('chat_history_technician${_technician!.id}');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text(
                        'Delete Chat'.tr(),
                        style: GoogleFonts.castoro(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: DashChat(
            currentUser: _technician!,
            onSend: onSend,
            messages: messages,
            inputOptions: InputOptions(
              cursorStyle: CursorStyle(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.grey[300]
                    : Colors.grey[700],
              ),
              inputDecoration: InputDecoration(
                hintText: 'Type your message here'.tr(),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                isDense: true,
                isCollapsed: true,
                filled: true,
                fillColor: themeProvider.themeMode == ThemeMode.dark
                    ? const Color(0xFF333739)
                    : Colors.white,
                hintStyle: GoogleFonts.castoro(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              inputTextStyle: GoogleFonts.castoro(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
              sendButtonBuilder: (Function send) {
                return IconButton(
                  icon: Icon(Icons.send,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : ApplicationColor,
                      size: 30),
                  onPressed: () => send(),
                  color: ApplicationColor,
                );
              },
            ),
            messageOptions: MessageOptions(
              currentUserContainerColor: ApplicationColor,
              currentUserTextColor: Colors.white,
              containerColor: Colors.grey.shade200,
              textColor: Colors.black,
            ),
          ),
        ));
  }
}
