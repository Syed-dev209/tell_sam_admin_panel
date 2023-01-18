import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';
import 'package:tell_sam_admin_panel/modules/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBFRkMWwZKHbyoRztZHBt1ra5ZFkOylaRE",
          authDomain: "tell-sam-admin-panel.firebaseapp.com",
          projectId: "tell-sam-admin-panel",
          storageBucket: "tell-sam-admin-panel.appspot.com",
          messagingSenderId: "409926758273",
          appId: "1:409926758273:web:e01dee19caa7a85948c280"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationServices.navigationKey,
      title: 'Tell Sam Admin panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
