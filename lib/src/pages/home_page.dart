import 'package:flutter/material.dart';

import '../utils/deep_link_handler.dart';
import '../utils/launch_url.dart';
import '../utils/notification_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (DeeplinkHandler.hasInitialLink) {
        final initialLink = DeeplinkHandler.initialLink;
        final route = initialLink.split(':/').last;
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                UrlLauncher.launchUrl('https://marketplace.visualstudio.com/items?itemName=emanuel-braz.deeplink');
              },
              child: const ListTile(
                title: Text('Open Mobile Dev Tools page'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                UrlLauncher.launchUrl('example://details');
              },
              child: const ListTile(
                title: Text('Open deeplink'),
                subtitle: Text('deeplink -> example://details'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationHandler.scheduleNotification(
                  {
                    'title': 'Send Local Notification',
                    'body': 'Using userInfo to pass data',
                    'userInfo': {
                      'myString': 'foo',
                      'myJson': {'name': 'Emanuel', 'lastName': 'Braz'},
                      'myList': ['foo', 'bar']
                    },
                  },
                );
              },
              child: const ListTile(
                title: Text('Local notification'),
                subtitle: Text('Use the Mobile Dev Tools to launch the app in the background'),
              ),
            ),
          ].map((e) => Padding(padding: const EdgeInsets.only(bottom: 16), child: e)).toList(),
        ),
      ),
    );
  }
}
