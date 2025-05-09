import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification_nodejs.dart';

Future<void> sendTechnicianNotification(
    String userId, String orderId, String serviceTitle) async {
  final techniciansRef = FirebaseFirestore.instance.collection('technician');
  final techniciansSnapshot = await techniciansRef.get();

  print("Looking for technicians matching: $serviceTitle");

  for (var technicianDoc in techniciansSnapshot.docs) {
    dynamic rawSubservices = technicianDoc['sub_service'];
    List<String> subservices = [];

    if (rawSubservices is List) {
      subservices = rawSubservices.map((e) => e.toString().trim()).toList();
    } else if (rawSubservices is String) {
      subservices = rawSubservices.split(',').map((e) => e.trim()).toList();
    }

    print("Technician ${technicianDoc.id} services: $subservices");

    // التحقق من حالة الفني (هل هو داخل التطبيق؟)
    bool isTechnicianActive =
        technicianDoc['isActive'] ?? false; // إذا كانت القيمة موجودة

    if (subservices.contains(serviceTitle) && isTechnicianActive) {
      print("✅ Match found for technician ${technicianDoc.id}");

      final notificationService = NotificationServices();
      String? technicianToken = technicianDoc['fcmToken'];

      if (technicianToken != null && technicianToken.isNotEmpty) {
        await notificationService.sendNotifications(
          fcmToken: technicianToken,
          title: "New Order Available",
          body: "A new order that matches your service is available now.",
          userId: technicianDoc.id,
          orderId: orderId,
        );
        print("notification pushed to $technicianToken");
      }
    } else {
      print(
          "❌ No match for ${technicianDoc.id} with $serviceTitle or not active");
    }
  }
}

Future<void> sendClientNotification(String userId) async {
  final notificationService = NotificationServices();
  String? token = await notificationService.getDeviceToken();

  if (token != null) {
    await notificationService.sendNotifications(
      fcmToken: token,
      title: "Order Placed Successfully",
      body: "Congratulations on your order! Technicians will offer soon.",
      userId: userId,
    );
  }
}

Future<void> sendClientOfferNotification(
    String userId, String orderId, String serviceTitle) async {
  try {
    final clientDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!clientDoc.exists) {
      print("❌ Client document not found for $userId");
      return;
    }

    // Get the FCM token for the client
    String? clientToken = clientDoc['fcmToken'];
    print("📦 FCM Token: $clientToken");

    // Send notification to client if their FCM token is valid
    if (clientToken != null && clientToken.isNotEmpty) {
      final notificationService = NotificationServices();
      await notificationService.sendNotifications(
        fcmToken: clientToken,
        title: 'New Offer for Your Service',
        body: 'A technician has made an offer on your service: $serviceTitle',
        userId: userId,
        orderId: orderId,
      );
      print("✅ Push notification sent to client $userId");
    } else {
      print("⚠️ No valid FCM token found for $userId");
    }
  } catch (e) {
    print("❌ Error sending notification: $e");
  }
}
