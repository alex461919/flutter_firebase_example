import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_firebase_example/firebase_config.dart';
import 'package:flutter_firebase_example/src/mix.dart';

abstract class FCMTokenState {}

class InitFCMTokenState extends FCMTokenState {}

class PendingFCMTokenState extends FCMTokenState {}

class CompleteFCMTokenState extends FCMTokenState {
  final String token;
  CompleteFCMTokenState(this.token);
  String get() => token;
}

class RejectedFCMTokenState extends FCMTokenState {
  final Exception error;
  final Completer<void>? confirmed;
  RejectedFCMTokenState(this.error, [this.confirmed]);
  Exception get() => error;
}

abstract class AuthState {}

class PendingAuthState extends AuthState {}

class WaitFCMTokenAuthState extends AuthState {
  final User user;
  WaitFCMTokenAuthState(this.user);
  User get() => user;
}

class IsAuthenticatedAuthState extends AuthState {
  final User user;
  IsAuthenticatedAuthState(this.user);
  User get() => user;
}

/*
class RejectedAuthState extends AuthState {
  final Exception error;

  RejectedAuthState(this.error);
  Exception get() => error;
}
*/
class AppAuthState {
  final AuthState authState;
  final FCMTokenState fcmTokenState;
  AppAuthState({required this.authState, required this.fcmTokenState});
  factory AppAuthState.init() => AppAuthState(authState: PendingAuthState(), fcmTokenState: InitFCMTokenState());

  AppAuthState copyWith({AuthState? authState, FCMTokenState? fcmTokenState}) {
    return AppAuthState(authState: authState ?? this.authState, fcmTokenState: fcmTokenState ?? this.fcmTokenState);
  }
}

class AppAuthStateNotifier extends StateNotifier<AppAuthState> {
  late final StreamSubscription<User?> streamSubscription;

  AppAuthStateNotifier([AppAuthState? initState]) : super(initState ?? AppAuthState.init()) {
    FirebaseAuth.instance
        .authStateChanges()
        .switchMap(tokenReceiver)
        .distinct((s1, s2) =>
            s1.authState.runtimeType == s2.authState.runtimeType && s1.fcmTokenState.runtimeType == s2.fcmTokenState.runtimeType)
        .listen((event) {
      state = event;
    });
  }

  Stream<AppAuthState> tokenReceiver(User? user) async* {
    if (user == null) {
      yield AppAuthState.init();
    } else {
      try {
        yield AppAuthState(authState: WaitFCMTokenAuthState(user), fcmTokenState: PendingFCMTokenState());

        await saveToDB(<String, dynamic>{
          'displayName': user.displayName,
          'email': user.email,
          'providerId': user.providerData.isNotEmpty ? user.providerData[0].providerId : '',
          'uid': user.uid,
          'signIn_at': FieldValue.serverTimestamp(),
          'refresh_at': FieldValue.serverTimestamp(),
        }).onError((error, stackTrace) => null);
        //  await Future.delayed(const Duration(seconds: 1));

        final token = await FirebaseMessaging.instance.getToken(vapidKey: VAPI_KEY);
        if (token != null) {
          await saveToDB(<String, dynamic>{
            'uid': user.uid,
            'fcmToken': token,
            'fcmTokenRefresh_at': FieldValue.serverTimestamp(),
          }).onError((error, stackTrace) => null);
          // throw Exception('Error! Error!');

          yield AppAuthState(authState: IsAuthenticatedAuthState(user), fcmTokenState: CompleteFCMTokenState(token));
        } else {
          throw Exception('Fcm token is null!');
        }
      } catch (error) {
        final confirmed = Completer<void>();
        final exception = error is Exception ? error : Exception(error.toString());
        yield AppAuthState(
          authState: WaitFCMTokenAuthState(user),
          fcmTokenState: RejectedFCMTokenState(exception, confirmed),
        );
        await confirmed.future;
        yield AppAuthState(
          authState: IsAuthenticatedAuthState(user),
          fcmTokenState: RejectedFCMTokenState(exception),
        );
      }
    }
  }

  void confirmFCMTokerError() {
    if (state.fcmTokenState is RejectedFCMTokenState) {
      final completer = (state.fcmTokenState as RejectedFCMTokenState).confirmed;
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
    }
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}

final appAuthProvider = StateNotifierProvider<AppAuthStateNotifier, AppAuthState>((ref) => AppAuthStateNotifier());
