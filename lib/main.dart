import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';
import 'package:tell_sam_admin_panel/modules/dashboard/dashboard_screen.dart';
import 'package:tell_sam_admin_panel/modules/locations/locations_screen.dart';
import 'package:tell_sam_admin_panel/modules/login/login_screen.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_screen.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
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
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ).copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ).copyWith(
          textTheme: GoogleFonts.poppinsTextTheme()
              .apply(bodyColor: Colors.white, displayColor: Colors.white)),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      // home: const DashboardScreen()
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
