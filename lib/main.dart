import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';
import 'package:tell_sam_admin_panel/modules/login/login_screen.dart';

void main() {
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

