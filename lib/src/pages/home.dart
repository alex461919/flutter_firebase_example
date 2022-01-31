import 'package:flutter_firebase_example/src/messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageList = useState(<RemoteMessage>[]);
    final message = ref.watch(foregroundMessagingProvider).value;
    final bgMessage = ref.watch(backgroundMessagingProvider).value;
    if (message != null) messageList.value.add(message);
    if (bgMessage != null) messageList.value.add(bgMessage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: [
        //  if (token != null) ...[Text(token!).padding(all: 16)],
        //  Permissions().padding(all: 16),
        Text('uid: ${FirebaseAuth.instance.currentUser?.uid ?? 'N/A'}').textAlignment(TextAlign.center).padding(vertical: 16),
        ListView.separated(
          padding: const EdgeInsets.all(16),
          //shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(
            height: 16,
          ),
          itemCount: messageList.value.length,
          itemBuilder: (context, index) {
            final message = messageList.value[index];
            RemoteNotification? notification = message.notification;
            return Column(
              children: [
                // row('Triggered application open', args.openedApplication.toString()),
                row('Message ID', message.messageId),
                row('Sender ID', message.senderId),
                row('Category', message.category),
                row('Collapse Key', message.collapseKey),
                row('Content Available', message.contentAvailable.toString()),
                row('Data', message.data.toString()),
                row('From', message.from),
                row('Message ID', message.messageId),
                row('Sent Time', message.sentTime?.toString()),
                row('Thread ID', message.threadId),
                row('Time to Live (TTL)', message.ttl?.toString()),
                if (notification != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Remote Notification',
                          style: TextStyle(fontSize: 18),
                        ),
                        row(
                          'Title',
                          notification.title,
                        ),
                        row(
                          'Body',
                          notification.body,
                        ),
                        if (notification.android != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Android Properties',
                            style: TextStyle(fontSize: 18),
                          ),
                          row(
                            'Channel ID',
                            notification.android!.channelId,
                          ),
                          row(
                            'Click Action',
                            notification.android!.clickAction,
                          ),
                          row(
                            'Color',
                            notification.android!.color,
                          ),
                          row(
                            'Count',
                            notification.android!.count?.toString(),
                          ),
                          row(
                            'Image URL',
                            notification.android!.imageUrl,
                          ),
                          row(
                            'Link',
                            notification.android!.link,
                          ),
                          row(
                            'Priority',
                            notification.android!.priority.toString(),
                          ),
                          row(
                            'Small Icon',
                            notification.android!.smallIcon,
                          ),
                          row(
                            'Sound',
                            notification.android!.sound,
                          ),
                          row(
                            'Ticker',
                            notification.android!.ticker,
                          ),
                          row(
                            'Visibility',
                            notification.android!.visibility.toString(),
                          ),
                        ],
                        if (notification.apple != null) ...[
                          const Text(
                            'Apple Properties',
                            style: TextStyle(fontSize: 18),
                          ),
                          row(
                            'Subtitle',
                            notification.apple!.subtitle,
                          ),
                          row(
                            'Badge',
                            notification.apple!.badge,
                          ),
                          row(
                            'Sound',
                            notification.apple!.sound?.name,
                          ),
                        ],
                        if (notification.web != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Web Properties',
                            style: TextStyle(fontSize: 18),
                          ),
                          row(
                            'AnalyticsLabel',
                            notification.web!.analyticsLabel,
                          ),
                          row(
                            'Image',
                            notification.web!.image,
                          ),
                          row(
                            'Link',
                            notification.web!.link,
                          ),
                        ]
                      ],
                    ),
                  )
                ]
              ],
            );
          },
        ).expanded(),
      ].toColumn(),
    );
  }

  Widget row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: '),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}
