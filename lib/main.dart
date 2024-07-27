import 'package:flutter/material.dart';

import 'src/utils/app_router.dart';
import 'src/utils/deep_link_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DeeplinkHandler();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'VSCode Extension Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
