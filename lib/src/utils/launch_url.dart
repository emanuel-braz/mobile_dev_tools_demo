import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UrlLauncher {
  static const _channel = MethodChannel('com.emanuelbraz.vscode/launch_url');

  static void launchUrl(String url) async {
    try {
      await _channel.invokeMethod('openBrowser', url);
    } on PlatformException catch (e) {
      debugPrint("Failed to open browser: '${e.message}'.");
    }
  }
}
