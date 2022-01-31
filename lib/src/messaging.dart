import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_firebase_example/src/mix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late final Stream<RemoteMessage> onBackgroundMessage;

void initMessaging() {
  FlutterAppBadger.isAppBadgeSupported().then((value) => {if (value) FlutterAppBadger.removeBadge()});

  final onBackgroundMessagePort = ReceivePort();

  IsolateNameServer.removePortNameMapping('onBackgroundMessagePort');
  IsolateNameServer.registerPortWithName(onBackgroundMessagePort.sendPort, 'onBackgroundMessagePort');
  onBackgroundMessage = onBackgroundMessagePort.asBroadcastStream().cast<RemoteMessage>();

  onBackgroundMessage.listen((message) {
    logger.d('Message from onBackgroundMessagePort: ${message.toString()}');
  });

  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageHandler);

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    logger.d('A new getInitialMessage event was published! ${message?.toString()}');
  });
  FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedAppHandler);
}

final foregroundMessagingProvider = StreamProvider.autoDispose((ref) => FirebaseMessaging.onMessage);

final backgroundMessagingProvider = StreamProvider.autoDispose((ref) => onBackgroundMessage);

void onMessageOpenedAppHandler(RemoteMessage message) {
  logger.d('onMessageOpenedApp. title: ${message.notification?.title}');
}

Future<void> _onBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final sendPort = IsolateNameServer.lookupPortByName('onBackgroundMessagePort');
  sendPort?.send(message);
  logger.d('A new onBackgroundMessage event was published! ${message.toString()}, port: $sendPort');
  if (message.data.containsKey('key1') && await FlutterAppBadger.isAppBadgeSupported()) {
    try {
      final badge = int.parse(message.data['key1']);
      FlutterAppBadger.updateBadgeCount(badge);
    } catch (_) {}
  }
}
