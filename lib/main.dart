import 'package:flutter/material.dart';

import 'src/utils/app_router.dart';
import 'src/utils/deep_link_handler.dart';
import 'src/utils/notification_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DeeplinkHandler();

  // This is not a real app implementation, so don't take this as a good practice.
  NotificationHandler((dynamic data) {
    debugPrint("Notification tapped: $data");
    NotificationHandler.showDialogWithPayload(data);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Mobile Dev Tools - VSCode',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
