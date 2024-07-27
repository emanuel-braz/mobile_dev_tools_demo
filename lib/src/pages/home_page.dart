import 'package:flutter/material.dart';

import '../utils/launch_url.dart';
import '../utils/notification_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                title: Text('Open deeplink using the Mobile Dev Tools'),
                subtitle: Text('example://showcase/product/123'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationHandler.scheduleNotification(
                  {
                    'title': 'Local Notification MethodChannel',
                    'body': 'Using userInfo to send data',
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
