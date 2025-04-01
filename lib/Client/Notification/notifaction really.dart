import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Theme/Theme_Provider.dart';
import 'Notification Item.dart';
import 'notification.dart';

class NotificationScreenReal extends StatefulWidget {
  const NotificationScreenReal({super.key});

  @override
  State<NotificationScreenReal> createState() => _NotificationScreenRealState();
}

class _NotificationScreenRealState extends State<NotificationScreenReal> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _setupNotifications();
  }

  void _setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted notification permission");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
        String messagePreview = _getMessagePreview(message.notification!.body);

        setState(() {
          notifications.insert(0, {
            "title": message.notification!.title ?? "New Notification",
            "preview": messagePreview,
            "date": formattedDate,
            "time": formattedTime,
          });
        });

        _saveNotifications();
        _showLocalNotification(
          message.notification!.title ?? "New Notification",
          message.notification!.body ?? "Tap to open",
        );
      }
    });
  }

  void _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  String _getMessagePreview(String? message) {
    if (message == null || message.isEmpty) {
      return "No message body";
    }
    return message.split(' ').take(5).join(' ') + "...";
  }

  void _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', jsonEncode(notifications));
  }

  void _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('notifications');
    if (storedData != null) {
      setState(() {
        notifications = List<Map<String, String>>.from(jsonDecode(storedData)
            .map((item) => Map<String, String>.from(item)));
      });
    }
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    _saveNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: notifications.isEmpty
          ? const NotificationScreen()
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationItem(
            title: notifications[index]["title"]!,
            preview: notifications[index]["preview"]!,
            time: notifications[index]["time"]!,
            profileImageUrl: "assets/images/lang-member/langmem.png",
            onDelete: () {
              _deleteNotification(
                  index); // Delete notification from within the item
            },
          );
        },
      ),
    );
  }
}
