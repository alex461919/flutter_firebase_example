// ignore_for_file: constant_identifier_names

import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutterfire_ui/auth.dart';

const GOOGLE_CLIENT_ID = '664089236150-asp4859li8gg8iqfe76t5rdl78eegk3c.apps.googleusercontent.com';
const VAPI_KEY = 'BCn7X5ZuzHWgW6TJzoWkariBDvT8rHieqlHktGyIwpeO0nud0G2ljdIbkL4OkWO7jVzCTecSC3TUKHoK7yoBCJM';

const ProviderConfigs = [EmailProviderConfiguration(), GoogleProviderConfiguration(clientId: GOOGLE_CLIENT_ID)];

class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDWbELxOMeeYD8SyGpaVSJX0bJkKbPYl2E',
        authDomain: 'test-firebase-project-44c66.firebaseapp.com',
        databaseURL: 'https://test-firebase-project-44c66-default-rtdb.firebaseio.com',
        projectId: 'test-firebase-project-44c66',
        storageBucket: 'test-firebase-project-44c66.appspot.com',
        messagingSenderId: '664089236150',
        appId: '1:664089236150:web:a92e2f1414caef97ee8c17',
        measurementId: 'G-HGYNPM96J8',
      );
    }
    if (Platform.isAndroid) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyC0dZRxJ7bS2R6CJbjC14P267VnBuNnL_U',
        appId: '1:664089236150:android:a92e2f1414caef97ee8c17',
        projectId: 'test-firebase-project-44c66',
        messagingSenderId: '664089236150',
      );
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
        appId: '1:448618578101:ios:4cd06f56e36384acac3efc',
        messagingSenderId: '448618578101',
        projectId: 'react-native-firebase-testing',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        iosBundleId: 'io.flutter.plugins.firebase.auth',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        iosClientId: '448618578101-m53gtqfnqipj12pts10590l37npccd2r.apps.googleusercontent.com',
        androidClientId: '448618578101-26jgjs0rtl4ts2i667vjb28kldvs2kp6.apps.googleusercontent.com',
        storageBucket: 'react-native-firebase-testing.appspot.com',
      );
    }
    return null;
  }
}
