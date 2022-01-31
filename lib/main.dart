import 'package:auto_route/auto_route.dart';
import 'package:flutter_firebase_example/firebase_config.dart';
import 'package:flutter_firebase_example/src/messaging.dart';
import 'package:flutter_firebase_example/src/mix.dart';
import 'package:flutter_firebase_example/src/pages/home.dart';
import 'package:flutter_firebase_example/src/pages/profile.dart';
import 'package:flutter_firebase_example/src/pages/sign_in.dart';
import 'package:flutter_firebase_example/src/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initMessaging();

  runApp(const ProviderScope(child: MyApp()));
}

class AuthGuard extends AutoRedirectGuard {
  final WidgetRef ref;
  User? user;

  AuthGuard(this.ref) {
    ref
        .read<AppAuthStateNotifier>(appAuthProvider.notifier)
        .stream
        .map((state) => state.authState is IsAuthenticatedAuthState ? (state.authState as IsAuthenticatedAuthState).user : null)
        .distinct()
        .listen((_user) {
      user = _user;
      reevaluate();
    });
  }

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (user != null) {
      resolver.next();
    } else {
      redirect(const SignInRoute(), resolver: resolver);
    }
  }
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(path: '/', page: HomePage, initial: true, guards: [AuthGuard]),
    AutoRoute(path: '/profile', page: ProfilePage, guards: [AuthGuard]),
    AutoRoute(path: '/sign-in', page: SignInPage),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = useState(AppRouter(authGuard: AuthGuard(ref))).value;
    final appAuthStateNotifier = ref.watch(appAuthProvider.notifier);
    useEffect(() {
      final subscription = appAuthStateNotifier.stream.listen((state) {
        logger.d(
            'AppAuthStateNotifier new state\nauthState: ${state.authState.runtimeType.toString()}\nfcmTokenState: ${state.fcmTokenState.runtimeType.toString()}');
      });
      return () => subscription.cancel();
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
