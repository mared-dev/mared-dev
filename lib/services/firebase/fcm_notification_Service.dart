import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

// abstract class IFCMNotificationService {
//   Future<void> sendNotificationToUser({
//     required String fcmToken,
//     required String title,
//     required String body,
//   });

// Future<void> sendNotificationToGroup({
//   required String group,
//   required String title,
//   required String body,
// });

// Future<void> unsubscribeFromTopic({
//   required String group,
// });

// Future<void> subscribeToTopic({
//   required String group,
// });
// }

class FCMNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _endpoint = "https://fcm.googleapis.com/fcm/send";
  final String _contentType = "application/json";
  final String _authorization =
      "Bearer AAAAtgj13CU:APA91bE8cb2iQQX4QfUQnOmdBucz4maQO-ULXJQr6EfDKoCqq-dVmccXGkxXHK09UYSBLrOPacHj_nLPZ9_PYyS39j7hjza6SqU9uivxaP23iOBfaGIBmxT9cONh-R33qu2m-XUdk4Z1";
  Future<http.Response?> sendNotificationToUser({
    required String to,
    required String title,
    required String body,
  }) async {
    try {
      final dynamic data = json.encode({
        'to': to,
        'priority': 'high',
        'notification': {
          'title': title,
          'body': body,
        },
        'content_available': true,
      });

      http.Response response =
          await http.post(Uri.parse(_endpoint), body: data, headers: {
        'Content-Type': _contentType,
        'Authorization': _authorization,
      });

      return response;
    } catch (e) {
      print("ERROR FCM ==== ${e.toString()}");
    }
  }
}
