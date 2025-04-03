import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<Map<String, dynamic>> notifications = [];  // Store document ID

  @override
  void initState() {
    super.initState();
    _loadNotificationsFromFirestore();  // Directly load notifications from Firestore
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
            "id": '',  // Placeholder for Firestore ID (can be updated after saving)
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

  Future<void> _saveNotificationToFirestore(Map<String, String> notificationData) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Add notification to Firestore and get document ID
    var docRef = await firestore.collection('notifications').add(notificationData);
    // Update the notification map with the document ID
    setState(() {
      notifications[0]["id"] = docRef.id;  // Set the Firestore document ID for the new notification
    });
  }

  Future<void> _loadNotificationsFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('notifications')
        .orderBy('date', descending: true)
        .get();

    setState(() {
      notifications = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,  // Store the Firestore document ID
          "title": doc["title"] as String,
          "preview": doc["preview"] as String,
          "date": doc["date"] as String,
          "time": doc["time"] as String,
        };
      }).toList();
    });
  }

  void _deleteNotification(int index) async {
    String notificationId = notifications[index]["id"];  // Get the Firestore document ID

    // Remove the notification locally
    setState(() {
      notifications.removeAt(index);
    });

    // Delete the notification from Firestore
    await FirebaseFirestore.instance.collection('notifications')
        .doc(notificationId)  // Reference the notification document by its ID
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notifications.isEmpty
          ? const NotificationScreen()  // Handle empty notification list UI
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
              _deleteNotification(index);  // Delete notification from within the item
            },
          );
        },
      ),
    );
  }
}