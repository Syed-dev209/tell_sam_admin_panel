import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';
import 'package:tell_sam_admin_panel/Utils/validators.dart';
import 'package:tell_sam_admin_panel/common/custom_text_field.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/dashboard/dashboard_screen.dart';
import 'package:tell_sam_admin_panel/modules/login/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscureText = true, buttonLoading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  width: size.width * 0.3,
                  controller: userName,
                  hintText: 'Enter username',
                  validator: Validators.requiredValidator,
                  prefix: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  width: size.width * 0.3,
                  controller: password,
                  hintText: 'Enter password',
                  validator: Validators.requiredValidator,
                  prefix: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  obscureText: obscureText,
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      )),
                ),
                const SizedBox(
                  height: 24,
                ),
                PrimaryButton(
                  loading: buttonLoading,
                  onTap: () => login(),
                  title: 'LOGIN',
                  width: size.width * 0.3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        buttonLoading = true;
      });
      bool result = await loginAdmin(userName.text, password.text);
      setState(() {
        buttonLoading = false;
      });
      if (result) {
        NavigationServices.pushReplaceScreen(const DashboardScreen());
      }
    }
  }
}
