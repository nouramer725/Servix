import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/Client/Home/HomeLayoutClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../AI/SERVICE.dart';
import '../../Theme/Theme_Provider.dart';
import '../../constents/constent.dart';

class ChatScreenClient extends StatefulWidget {
  const ChatScreenClient({super.key});

  @override
  State<ChatScreenClient> createState() => _ChatScreenClientState();
}

class _ChatScreenClientState extends State<ChatScreenClient> {
  ChatUser? _client;
  final ChatUser _bot = ChatUser(id: '2', firstName: 'Chatbot'.tr());
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
    if (_client != null) {
      await _loadChatHistory();
    }
  }

  Future<void> _loadTechnicianData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Fetch from "technicians" collection
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _client = ChatUser(
            id: firebaseUser.uid,
            firstName: userData['first_name'] ?? 'client',
          );
        });
      }
    }
  }

  Future<void> _saveChatHistory() async {
    if (_client == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatData = messages
        .map((msg) => jsonEncode({
              'text': msg.text,
              'userId': msg.user.id,
              'createdAt': msg.createdAt.toIso8601String(),
            }))
        .toList();
    await prefs.setStringList('chat_history_${_client!.id}', chatData);
  }

  Future<void> _loadChatHistory() async {
    if (_client == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatData = prefs.getStringList('chat_history_${_client!.id}');

    if (chatData != null) {
      setState(() {
        messages = chatData.map((data) {
          Map<String, dynamic> json = jsonDecode(data);
          return ChatMessage(
            text: json['text'],
            user: json['userId'] == _client!.id ? _client! : _bot,
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
    if (_client == null) {
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
            MaterialPageRoute(builder: (_) => const HomeClientLayout()),
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
                    await prefs.remove('chat_history_${_client!.id}');
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
                            fontSize: 15),
                      ),
                    ),
                  ];
                },
              )
            ],
          ),
          body: DashChat(
            currentUser: _client!,
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
