import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMsg {

  final msgService = FirebaseMessaging.instance;

  initFCM() async{
    await msgService.requestPermission();
    String? token = await msgService.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onBackgroundMessage(handleNotification);
    FirebaseMessaging.onMessage.listen(handleNotification);
  }
}

Future<void> handleNotification(RemoteMessage message) async {
  print("Notification received: ${message.notification?.title}");
  print("Notification body: ${message.notification?.body}");
  
}