import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'navigator_util.dart';

class DeeplinkHandler {
  static const MethodChannel _channel = MethodChannel('com.emanuelbraz.vscode/deeplink');

  DeeplinkHandler() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  // Important: For sake of simplicity, we are using navigator key here.
  // In a real app, you should use a better approach to handle navigation or dialogs.
  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onDeeplink') {
      String? deeplink = call.arguments as String?;
      if (deeplink != null) {
        debugPrint('Received deeplink: $deeplink');

        final uri = Uri.parse(deeplink);
        final route = deeplink.split(':/').last;

        showDialog(
          context: NavigatorUtil.key.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: const Text('Deeplink Received'),
              content: Text('''scheme: ${uri.scheme}
host: ${uri.host.isEmpty ? uri.path.split('/').first : uri.host}
path: ${uri.path}'''),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    NavigatorUtil.key.currentContext!.go(route);
                  },
                  child: const Text('Navigate'),
                ),
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
  }
}
