// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   NotificationService(this.flutterLocalNotificationsPlugin);
//
//   Future<void> showAndSaveNotification({
//     required String title,
//     required String preview,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'chat-app-ea642',
//       'servix',
//       channelDescription: 'This channel is for important notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     // Show local notification
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       preview,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//
//     // Save to Firestore
//     final notificationData = {
//       'title': title,
//       'preview': preview,
//       'date': DateFormat('dd MMM yyyy').format(DateTime.now()),
//       'time': DateFormat('hh:mm a').format(DateTime.now()),
//       'timestamp': DateTime.now().toIso8601String(),
//       'id': FirebaseFirestore.instance.collection('notifications').doc().id,
//     };
//
//     await FirebaseFirestore.instance
//         .collection('notifications')
//         .add(notificationData);
//   }
// }
