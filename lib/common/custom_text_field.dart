import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Widget? prefix;
  final double? width;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false,
      this.validator,
      this.suffix,
      this.prefix,
      this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: width??double.maxFinite,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffix,
            prefixIcon: prefix,
            fillColor: Colors.black.withOpacity(0.05),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
