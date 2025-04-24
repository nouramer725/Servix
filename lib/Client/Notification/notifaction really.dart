import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Notification Item.dart';
import 'No_notification.dart';

class NotificationScreenReal extends StatefulWidget {
  const NotificationScreenReal({super.key});

  @override
  State<NotificationScreenReal> createState() => _NotificationScreenRealState();
}

class _NotificationScreenRealState extends State<NotificationScreenReal> {
  List<Map<String, dynamic>> notifications = [];
  late final StreamSubscription<RemoteMessage> _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _loadNotificationsFromFirestore();
    _setupNotifications();
  }

  void _setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted notification permission");
    }

    _notificationSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null && mounted) {
        String messagePreview =
            _getMessagePreview(message.notification!.body ?? '');

        final notificationData = {
          "title": message.notification!.title ?? "New Notification",
          "preview": messagePreview,
          "time": DateFormat('hh:mm a').format(DateTime.now()),
          "date": DateFormat('dd MMM yyyy').format(DateTime.now()),
          "timestamp": FieldValue.serverTimestamp(),
        };

        try {
          await FirebaseFirestore.instance
              .collection('notifications')
              .add(notificationData);
          print("Notification saved to Firestore");

          setState(() {
            notifications.insert(0, {
              "title": notificationData["title"],
              "preview": notificationData["preview"],
              "time": DateFormat('hh:mm a').format(DateTime.now()),
              "date": DateFormat('dd MMM yyyy').format(DateTime.now()),
              "id": "", // Will not be used in local display for new ones
            });
          });
        } catch (e) {
          print("Error saving notification to Firestore: $e");
        }
      }
    });
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    super.dispose();
  }

  String _getMessagePreview(String? message) {
    if (message == null || message.isEmpty) {
      return "No message body";
    }
    return message.split(' ').take(20).join(' ');
  }

  Future<void> _loadNotificationsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        notifications = querySnapshot.docs.map((doc) {
          Timestamp? timestamp = doc["timestamp"];
          DateTime dateTime = timestamp?.toDate() ?? DateTime.now();
          return {
            "title": doc["title"],
            "preview": doc["preview"],
            "time": DateFormat('hh:mm a').format(dateTime),
            "date": DateFormat('dd MMM yyyy').format(dateTime),
            "id": doc.id,
          };
        }).toList();
      });
    } catch (e) {
      print("Error loading notifications: $e");
    }
  }

  void _deleteNotification(int index) async {
    try {
      String notificationId = notifications[index]["id"];
      if (notificationId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(notificationId)
            .delete();
      }

      setState(() {
        notifications.removeAt(index);
      });

      print("Notification deleted successfully");
    } catch (error) {
      print("Error deleting notification: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notifications.isEmpty
          ? const NotificationScreen() // Show no-notification UI
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationItem(
                  title: notifications[index]["title"] ?? '',
                  preview: notifications[index]["preview"] ?? '',
                  time: notifications[index]["time"] ?? '',
                  profileImageUrl: "assets/images/lang-member/langmem.png",
                  onDelete: () => _deleteNotification(index),
                );
              },
            ),
    );
  }
}
