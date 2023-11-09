import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";

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

    final fcmToken = await messaging.getToken();
    await storage.write(key: "fcmToken", value: fcmToken);
    print("FCM Token: $fcmToken");

    print("User granted permission: ${settings.authorizationStatus}");
  }
}

appFCMInit() {
  messaging.onTokenRefresh.listen((fcmToken) async {
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.

    final fcmToken = await messaging.getToken();
    await storage.write(key: "fcmToken", value: fcmToken);
  }).onError((err) {
    if (kDebugMode) {
      print(err);
    }
  });
}

handleForegroundMasseges() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got a message whilst in the foreground!");
    print("Message data: ${message.data}");

    if (message.notification != null) {
      print("Message also contained a notification: "
          "Title:\n${message.notification?.title}\n"
          "Body:\n${message.notification?.body}\n"
          "Data:\n${message.data}");
    }
  });
}

@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");

  if (message.notification != null) {
    print("Message also contained a notification: "
        "Title:\n${message.notification?.title}\n"
        "Body:\n${message.notification?.body}\n"
        "Data:\n${message.data}");
  }
}
