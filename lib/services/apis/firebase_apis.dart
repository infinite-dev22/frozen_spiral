import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:intl/intl.dart";
import "package:smart_case/models/local/notifications.dart";

import "../../util/smart_case_init.dart";

FirebaseMessaging messaging = FirebaseMessaging.instance;

class FirebaseApi {
  Future<void> initPushNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    currentUserFcmToken = await messaging.getToken();

    if (kDebugMode) {
      print("FCM Token: $currentUserFcmToken");
    }
  }
}

appFCMInit() {
  messaging.onTokenRefresh.listen((fcmToken) async {
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.

    currentUserFcmToken = await messaging.getToken();
  }).onError((err) {
    if (kDebugMode) {
      print(err);
    }
  });
}

handleForegroundMasseges() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _storeForegroundNotification(message);

    if (kDebugMode) {
      print("Got a message whilst in the foreground!");
      print("Message data: ${message.data}");
    }

    if (message.notification != null) {
      if (kDebugMode) {
        print("Message also contained a notification: "
            "Title:\n${message.notification?.title}\n"
            "Body:\n${message.notification?.body}\n"
            "Data:\n${message.data}");
      }
    }
  });
}

_storeForegroundNotification(RemoteMessage message) async {
  String time = DateFormat('h:mm a').format(DateTime.now());

  await localStorage?.add(Notifications(
      title: message.notification?.title,
      body: message.notification?.body,
      time: time));
}

@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }

  if (message.notification != null) {
    if (kDebugMode) {
      print("Message also contained a notification: "
          "Title:\n${message.notification?.title}\n"
          "Body:\n${message.notification?.body}\n"
          "Data:\n${message.data}");
    }
  }
}
