import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/detail_page.dart';
import '../pages/home_page.dart';
import 'navigator_util.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigatorUtil.key,
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/showcase/product/:productId',
        builder: (BuildContext context, GoRouterState state) {
          final productId = state.pathParameters['productId'];
          return DetailsPage(productId: productId);
        },
      ),
    ],
  );
}
