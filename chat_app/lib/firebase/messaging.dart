import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Messaging {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static initializeMessaging() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectionNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
      await handleMessage(message);
    });
  }

  static Future<dynamic> selectionNotification(String payload) async {
    print('payload: $payload');
  }

  static handleMessage(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('CHAT', "CHAT", 'CHAT', importance: Importance.max, priority: Priority.high, showWhen: true);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(0, "New Messages", message.data['sender'] + ": " + message.data['message'], platformChannelSpecifics,
        payload: 'CHAT');
  }

  static Future<String> getToken() async {
    return await _fcm.getToken();
  }
}
