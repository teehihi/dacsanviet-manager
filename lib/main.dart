import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app.dart';
import 'domain/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init Notification Service
  final notifService = NotificationService();
  await notifService.init();

  // Set background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const DacSanVietManagerApp());
}
