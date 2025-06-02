import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Client/Offers/Model/Offer.dart';
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

bool _isSending = false;

Future<void> sendClientOfferNotification({
  required String clientId,
  required String technicianName,
}) async {
  if (_isSending) return; // Prevent duplicate execution
  _isSending = true;

  try {
    final clientDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(clientId)
        .get();
    final clientData = clientDoc.data();

    if (clientData == null) {
      print("❌ Client data not found");
      return;
    }

    final fcmToken = clientData['fcmToken'];
    if (fcmToken != null && fcmToken.isNotEmpty) {
      final notificationService = NotificationServices();
      await notificationService.sendNotifications(
        fcmToken: fcmToken,
        title: "You've Received an Offer".tr(),
        body: "$technicianName has sent you an offer for your request.".tr(),
        userId: clientId,
      );
      print("✅ Notification sent to client $clientId");
    } else {
      print("❌ Client FCM token is missing");
    }
  } finally {
    _isSending = false;
  }
}

Future<void> sendOfferRejectedNotification(String technicianId) async {
  try {
    // Fetch the technician's FCM token
    final technicianDoc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(technicianId)
        .get();

    if (technicianDoc.exists) {
      final technicianData = technicianDoc.data();
      final fcmToken = technicianData?['fcmToken'];

      if (fcmToken != null && fcmToken.isNotEmpty) {
        // Send a notification to the technician
        final notificationService = NotificationServices();
        await notificationService.sendNotifications(
          fcmToken: fcmToken,
          title: "Offer Rejected".tr(),
          body: "Your offer for the order has been rejected.".tr(),
          userId: technicianId,
        );
        print("✅ Notification sent to technician $technicianId");
      } else {
        print("❌ Technician FCM token is missing");
      }
    }
  } catch (e) {
    print("🚨 Error sending notification to technician: $e");
  }
}

// Function to send notification to the technician when their offer is accepted
Future<void> sendOfferAcceptedNotification(Offer offer) async {
  try {
    final technicianId = offer.technicianId;

    // Fetch the technician's FCM token
    final technicianDoc = await FirebaseFirestore.instance
        .collection('technician')
        .doc(technicianId)
        .get();

    if (technicianDoc.exists) {
      final technicianData = technicianDoc.data();
      final fcmToken = technicianData?['fcmToken'];

      if (fcmToken != null && fcmToken.isNotEmpty) {
        // Send a notification to the technician
        final notificationService = NotificationServices();
        await notificationService.sendNotifications(
          fcmToken: fcmToken,
          title: "Offer Accepted",
          body:
              "Your offer for the order is accepted and the order is now in progress.",
          userId: technicianId,
        );
        print("✅ Notification sent to technician $technicianId");
      } else {
        print("❌ Technician FCM token is missing");
      }
    }
  } catch (e) {
    print("🚨 Error sending notification to technician: $e");
  }
}

Future<String?> getClientFcmToken(String clientId) async {
  final clientDoc =
      await FirebaseFirestore.instance.collection('users').doc(clientId).get();
  if (clientDoc.exists) {
    final data = clientDoc.data();
    return data?['fcmToken'];
  }
  return null;
}

Future<String?> getTechnicianFcmToken(String technicianId) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection(
            'technician') // Assuming you store technicians under this collection
        .doc(technicianId) // Use the technician's ID
        .get();
    return docSnapshot
        .data()?['fcmToken']; // Assuming the token is stored as 'fcmToken'
  } catch (e) {
    print("Error fetching technician FCM token: $e");
    return null;
  }
}
