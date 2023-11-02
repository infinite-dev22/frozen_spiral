import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:smart_case/models/smart_requisition.dart";

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

class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['screen'] == "Requisitions") {
      Navigator.pushNamed(context, '/requisition',
          arguments: SmartRequisition.fromJson(message.data['requisition']));
    }
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Text("...");
  }
}
