import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
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

        // Save notification to Firestore for syncing across all devices
        await _saveNotificationToFirestore({
          "title": message.notification!.title ?? "New Notification",
          "preview": messagePreview,
          "date": formattedDate,
          "time": formattedTime,
        });

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
      0, title, body, platformChannelSpecifics,
    );
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

    // Load notifications from Firestore as well
    await _loadNotificationsFromFirestore();
  }

  Future<void> _saveNotificationToFirestore(Map<String, String> notificationData) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('notifications').add(notificationData);
  }

  Future<void> _loadNotificationsFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('notifications').get();

    setState(() {
      notifications = querySnapshot.docs.map((doc) {
        return {
          "title": doc["title"] as String, // Ensure it's a string
          "preview": doc["preview"] as String, // Ensure it's a string
          "date": doc["date"] as String, // Ensure it's a string
          "time": doc["time"] as String, // Ensure it's a string
        };
      }).toList();
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    _saveNotifications();
  }

  @override
  Widget build(BuildContext context) {
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
              _deleteNotification(index); // Delete notification from within the item
            },
          );
        },
      ),
    );
  }
}
