import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigator_util.dart';

class DeeplinkHandler {
  static var _initialLink = '';
  static String get initialLink {
    final link = _initialLink;
    _initialLink = '';
    return link;
  }

  static get hasInitialLink => _initialLink.isNotEmpty;
  static const MethodChannel _channel = MethodChannel('com.emanuelbraz.vscode/deeplink');

  DeeplinkHandler() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  // Important: For sake of simplicity, we are using navigator key here.
  // In a real app, you should use a better approach to handle navigation or dialogs.
  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onDeeplink') {
      String? deeplink = call.arguments as String?;
      debugPrint('Received deeplink: $deeplink');

      if (deeplink != null) {
        if (!hasInitialLink) {
          _initialLink = deeplink;
        }

        final context = NavigatorUtil.key.currentContext;
        if (context == null || !context.mounted) {
          return;
        }

        final route = deeplink.split(':/').last;
        Navigator.of(NavigatorUtil.key.currentContext!).pushNamed(route);

        showDialog(
          context: NavigatorUtil.key.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: const Text('Deeplink received'),
              content: Text('Deeplink: $deeplink'),
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
  }
}
