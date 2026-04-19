import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize Firebase (Requires google-services.json on Android)
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e) {
      debugPrint('⚠️ Firebase Init skipped: Likely missing google-services.json: $e');
    }

    // 2. Local Notifications Setup
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('🔔 Notification clicked: ${details.payload}');
      },
    );

    // Create Notification Channel for Android
    const androidChannel = AndroidNotificationChannel(
      'admin_channel',
      'Admin Notifications',
      description: 'Notifications for new orders and activities',
      importance: Importance.max,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Request Android notification permission (for Android 13+)
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // 3. Request Permissions & Handle FCM (Only if Firebase is initialized)
    if (Firebase.apps.isNotEmpty) {
      try {
        await FirebaseMessaging.instance.requestPermission();

        // 4. Handle Foreground FCM messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          showLocalNotification(
            title: message.notification?.title ?? 'Cập nhật mới',
            body: message.notification?.body ?? '',
            payload: message.data.toString(),
          );
        });
      } catch (e) {
        debugPrint('⚠️ Firebase Messaging setup failed: $e');
      }
    } else {
      debugPrint('ℹ️ FCM setup skipped because Firebase is not initialized');
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'admin_channel',
      'Admin Notifications',
      channelDescription: 'Notifications for new orders and activities',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails();
    const platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  Future<String?> getFCMToken() async {
    if (Firebase.apps.isEmpty) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('⚠️ Error getting FCM token: $e');
      return null;
    }
  }
}

// Background handler for FCM
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    debugPrint("Handling a background message: ${message.messageId}");
  } catch (e) {
    debugPrint('⚠️ Background Firebase init failed: $e');
  }
}
