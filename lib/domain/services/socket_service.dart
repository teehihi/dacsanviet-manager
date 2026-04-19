import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../api_config.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? socket;
  Function(dynamic)? onNotificationReceived;

  void connect(String token) {
    if (socket != null && socket!.connected) return;

    socket = io.io(ApiConfig.baseUrl, io.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({'token': token})
      .enableAutoConnect()
      .build());

    socket!.onConnect((_) {
      debugPrint('🔌 Socket Connected: ${socket!.id}');
    });

    socket!.onDisconnect((_) {
      debugPrint('🔌 Socket Disconnected');
    });

    socket!.onConnectError((err) {
      debugPrint('🔌 Socket Connection Error: $err');
    });

    // Listen for general notifications
    socket!.on('notification', (data) {
      debugPrint('📢 New Notification: $data');
      if (onNotificationReceived != null) {
        onNotificationReceived!(data);
      }
    });

    // Listen for admin events
    socket!.on('admin_notification', (data) {
      debugPrint('📢 Admin Notification: $data');
      if (onNotificationReceived != null) {
        onNotificationReceived!(data);
      }
    });

    socket!.connect();
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }

  void emit(String event, dynamic data) {
    socket?.emit(event, data);
  }
}
