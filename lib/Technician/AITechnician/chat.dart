import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
  final ChatUser _bot = ChatUser(id: '2', firstName: 'Gemini');
  final GeminiService _geminiService = GeminiService();
  List<ChatMessage> messages = [];

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatData = messages
        .map((msg) => jsonEncode({
              'text': msg.text,
              'userId': msg.user.id,
              'createdAt': msg.createdAt.toIso8601String(),
            }))
        .toList();
    await prefs.setStringList('chat_history_technician', chatData);
  }

  Future<void> _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatData = prefs.getStringList('chat_history_technician');

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
    });
    _saveChatHistory();

    String aiResponse = await _geminiService.sendMessage(message.text);

    ChatMessage botMessage = ChatMessage(
      text: aiResponse,
      user: _bot,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.insert(0, botMessage);
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

    return Scaffold(
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
            onSelected: (String value) {
              if (value == 'Delete') {
                setState(() {
                  messages.clear();
                });
                _saveChatHistory();
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
        currentUser: _technician!,
        onSend: onSend,
        messages: messages,
        messageListOptions:
            MessageListOptions(dateSeparatorBuilder: (DateTime date) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat('yyyy-MM-dd').format(date),
              style: GoogleFonts.castoro(
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          );
        }),
        inputOptions: InputOptions(
          cursorStyle: CursorStyle(
            color: themeProvider.themeMode == ThemeMode.dark
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
          // trailing: [
          //   IconButton(
          //       icon: Icon(Icons.camera_alt,
          //           color: themeProvider.themeMode == ThemeMode.dark
          //               ? Colors.white
          //               : Colors.black,
          //           size: 30),
          //       onPressed: () async {
          //         final ImagePicker picker = ImagePicker();
          //         final XFile? image =
          //             await picker.pickImage(source: ImageSource.camera);
          //
          //         if (image != null) {
          //           File imageFile = File(image.path);
          //           print("Picked image path: ${imageFile.path}");
          //         } else {
          //           print("No image selected.");
          //         }
          //       }),
          // ],
          inputDecoration: InputDecoration(
            hintText: 'Type your message here'.tr(),
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
              borderSide: BorderSide(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
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
    );
  }
}
