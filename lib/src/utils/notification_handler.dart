import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigator_util.dart';

class NotificationHandler {
  static const MethodChannel _channel = MethodChannel('com.emanuelbraz.vscode/notification_channel');
  final void Function(dynamic data) listenToNotificationTap;

  NotificationHandler(this.listenToNotificationTap) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == "onNotificationTap") {
      listenToNotificationTap.call(call.arguments);
    }
  }

  static Future<void> scheduleNotification(Map<String, dynamic> data) async {
    try {
      await _channel.invokeMethod('scheduleLocalNotification', data);
    } on PlatformException catch (e) {
      debugPrint("Failed to schedule notification: ${e.message}");
    }
  }

  static showDialogWithPayload(dynamic data) {
    if (data == null) return;

    showDialog(
      context: NavigatorUtil.key.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notification Received'),
          content: Text(data.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
