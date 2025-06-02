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

  bool isFirstChat = false;
  final List<String> defaultSuggestions = [
    'What is Servix?',
    'What services does Servix offer?',
    'How to fix a broken appliance?',
    'How to deep clean a living room?',
    'How to request home beauty services?',
    'How to find a caregiver for the elderly?',
    'Update your profile to get better matches',
    'Track your service requests in real-time',
    'Learn how to order a technician with one tap',
    'Manage your bookings and appointments easily',
    'Enable notifications to stay updated',
    'Rate your recent service experience'
  ];

  final Map<String, String> aiResponses = {
    'How to fix a broken appliance?':
        '✅ You can book a technician from the Devices Maintenance section. Describe your issue, and an expert will be assigned to help.',
    'How to deep clean a living room?':
        '✅ Choose a Home service in the app, select "Cleaning", and schedule your preferred time.',
    'How to request home beauty services?':
        '✅ Go to the For Woman section, select the service you need (e.g., Henna, nails), and book an appointment.',
    'How to find a caregiver for the elderly?':
        '✅ Visit the Care section, browse available professionals, and request the one that matches your needs.',
    'Update your profile to get better matches':
        '✅ Navigate to your profile tab, tap "Edit Profile", and fill out your skills, experience, and availability.',
    'Track your service requests in real-time':
        '✅ Go to the "Orders Screen" tab to see updates, technician status, and completion progress.',
    'Learn how to order a technician with one tap':
        '✅ From the Navigation Bar, tap on the home icon , you can make any requests for services and confirm your request.',
    'Manage your bookings and appointments easily':
        '✅ All your scheduled services can be managed in the "Bookings" tab where you can reschedule or cancel.',
    'Enable notifications to stay updated':
        '✅ Go to Settings > Notifications and make sure alerts for new bookings and messages are turned on.',
    'Rate your recent service experience':
        '✅ After a service ends, you’ll be prompted to give a star rating and leave a review to help others.',
    'What is Servix?':
        '✅ A Comprehensive Multi-Service Platform – Bridging Clients and Technicians',
    'What services does Servix offer?':
        '✅ Home services such as plumbing, electrical repairs, carpentry, and general maintenance. \n Personal services like beauty treatments, grooming, and wellness services.\n Educational services including private tutoring and lessons for various subjects and skills. \n Delivery and transportation services.\n Care services for elderly, children, and people with disabilities'
  };

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadClientData();
    if (_client != null) {
      await _loadChatHistory();
    }
  }

  Future<void> _loadClientData() async {
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

    if (chatData != null && chatData.isNotEmpty) {
      setState(() {
        isFirstChat = false;
        messages = chatData.map((data) {
          Map<String, dynamic> json = jsonDecode(data);
          return ChatMessage(
            text: json['text'],
            user: json['userId'] == _client!.id ? _client! : _bot,
            createdAt: DateTime.parse(json['createdAt']),
          );
        }).toList();
      });
    } else {
      setState(() {
        isFirstChat = true;
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

    String aiResponse;

    // ✅ Check static map before calling Gemini
    if (aiResponses.containsKey(message.text)) {
      aiResponse = aiResponses[message.text]!;
    } else {
      aiResponse = await _geminiService.sendMessage(message.text);
    }

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
            body: Column(children: [
              if (messages.isEmpty) _buildFirstTimeSuggestions(),
              Expanded(
                flex: 2,
                child: DashChat(
                  currentUser: _client!,
                  onSend: onSend,
                  messages: messages,
                  inputOptions: InputOptions(
                    textInputAction: TextInputAction.done,
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
              )
            ])));
  }

  Widget _buildFirstTimeSuggestions() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Define a list of colors
    final List<Color> suggestionColors = [
      ApplicationColor,
      const Color(0xFF333739),
      const Color(0xFFB1B1B1),
    ];
    // Split suggestions into rows of 4
    List<List<String>> rows = [];
    int itemsPerRow = 4;
    for (int i = 0; i < defaultSuggestions.length; i += itemsPerRow) {
      rows.add(defaultSuggestions.sublist(
        i,
        (i + itemsPerRow > defaultSuggestions.length)
            ? defaultSuggestions.length
            : i + itemsPerRow,
      ));
    }

    // Hash function to consistently assign color to each suggestion
    int getColorIndex(String suggestion) {
      return suggestion.codeUnits.fold(0, (prev, char) => prev + char) %
          suggestionColors.length;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How can I help you today?'.tr(),
              style: GoogleFonts.castoro(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...rows.map((rowSuggestions) {
              return Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: rowSuggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final suggestion = rowSuggestions[index];
                    final color = suggestionColors[getColorIndex(suggestion)];

                    return GestureDetector(
                      onTap: () {
                        ChatMessage message = ChatMessage(
                          text: suggestion,
                          user: _client!,
                          createdAt: DateTime.now(),
                        );
                        setState(() {
                          isFirstChat = false;
                        });
                        onSend(message);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            suggestion,
                            style: GoogleFonts.castoro(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
