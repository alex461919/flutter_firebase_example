import 'package:flutter_firebase_example/src/mix.dart';
import 'package:flutter_firebase_example/src/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter_firebase_example/firebase_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<FCMTokenState>(appAuthProvider.select((state) => state.fcmTokenState), (previous, next) async {
      if (next is RejectedFCMTokenState) {
        await showErrorMessage(context, next.get());
        ref.read(appAuthProvider.notifier).confirmFCMTokerError();
      }
    });
    final pendingFCMToken = ref.watch(appAuthProvider.select((value) => value.fcmTokenState is PendingFCMTokenState));

    return LoadingOverlay(
      child: SignInScreen(
        providerConfigs: ProviderConfigs,
        actions: [
          AuthStateChangeAction<SignedIn>(
            (context, state) {},
          ),
        ],
      ),
      isLoading: pendingFCMToken,
      // demo of some additional parameters
      opacity: 0.5,
      progressIndicator: const CircularProgressIndicator(),
      color: Theme.of(context).colorScheme.surface,
    );
  }
}
