import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/validators.dart';
import 'package:tell_sam_admin_panel/common/custom_text_field.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/login/auth_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonLoading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.maxFinite,
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(
                      minWidth: 200,
                      maxWidth: 500,
                      minHeight: 52,
                      maxHeight: 52),
                  child: CustomTextField(
                    controller: oldPass,
                    hintText: 'Enter current password',
                    obscureText: true,
                    validator: Validators.requiredValidator,
                    prefix: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  constraints: const BoxConstraints(
                      minWidth: 200,
                      maxWidth: 500,
                      minHeight: 52,
                      maxHeight: 52),
                  child: CustomTextField(
                    controller: newPass,
                    hintText: 'Enter new password',
                    obscureText: true,
                    validator: Validators.requiredValidator,
                    prefix: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 52,
                    maxHeight: 52,
                    minWidth: 200,
                    maxWidth: 500,
                  ),
                  child: PrimaryButton(
                    loading: buttonLoading,
                    onTap: () => changePassword(),
                    title: 'Save',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  changePassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        buttonLoading = true;
      });
      bool check = await changeAdminPassword(oldPass.text, newPass.text);
      setState(() {
        buttonLoading = false;
        newPass.clear();
        oldPass.clear();
      });
    }
  }
}
