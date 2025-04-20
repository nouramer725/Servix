import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'No_notification.dart';
import 'Notification Item.dart';

class NotificationScreenRealTech extends StatefulWidget {
  const NotificationScreenRealTech({super.key});

  @override
  State<NotificationScreenRealTech> createState() =>
      _NotificationScreenRealTechState();
}

class _NotificationScreenRealTechState
    extends State<NotificationScreenRealTech> {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotificationsFromFirestore(); // Directly load notifications from Firestore
    _setupNotifications();
  }

  void _setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted notification permission");
    }

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);
    //
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
        String messagePreview = _getMessagePreview(message.notification!.body);
        print("Received notification: ${message.notification!.body}");

        setState(() {
          notifications.insert(0, {
            "title": message.notification!.title ?? "New Notification",
            "preview": messagePreview,
            "date": formattedDate,
            "time": formattedTime,
            "id":
                "", // Placeholder ID, will be updated after saving to Firestore
          });
        });

        // Save notification to Firestore for syncing across all devices
        await _saveNotificationToFirestore({
          "title": message.notification!.title ?? "New Notification",
          "preview": messagePreview,
          "date": formattedDate,
          "time": formattedTime,
          "id": "", // Placeholder ID, will be updated after saving to Firestore
        });

        // _showLocalNotification(
        //   message.notification!.title ?? "New Notification",
        //   message.notification!.body ?? "Tap to open",
        // );
      }
    });
  }

  // void _showLocalNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'channel_id',
  //     'General Notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     playSound: true,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //   );
  // }

  String _getMessagePreview(String? message) {
    if (message == null || message.isEmpty) {
      return "No message body";
    }
    return message.split(' ').take(20).join(' ');
  }

  Future<void> _saveNotificationToFirestore(
      Map<String, String> notificationData) async {
    final docRef =
        FirebaseFirestore.instance.collection('notificationsTech').doc();

    await docRef.set({
      "title": notificationData["title"],
      "preview": notificationData["preview"],
      "date": notificationData["date"],
      "time": notificationData["time"],
      "timestamp": FieldValue.serverTimestamp(),
      "id": docRef.id,
    });
  }

  Future<void> _loadNotificationsFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('notificationsTech')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      notifications = querySnapshot.docs.map((doc) {
        return {
          "title": doc["title"] as String,
          "preview": doc["preview"] as String,
          "date": doc["date"] as String,
          "time": doc["time"] as String,
          "id": doc["id"] as String,
        };
      }).toList();
    });
  }

  void _deleteNotification(int index) async {
    try {
      // Get the notification ID from the list before removing it
      String notificationId = notifications[index]["id"]!;

      // Delete notification from Firestore
      await FirebaseFirestore.instance
          .collection('notificationsTech')
          .doc(notificationId)
          .delete();
      print("Notification with ID $notificationId deleted from Firestore");

      // Remove from the local list
      setState(() {
        notifications.removeAt(index);
      });

      print("Notification removed from the UI");
    } catch (error) {
      print("Error deleting notification: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notifications.isEmpty
          ? const NotificationScreenTech() // Handle empty notification list UI
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationItemTech(
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
