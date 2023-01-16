import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final double? width;
  final double? height;
  final bool loading;
  const PrimaryButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.width,
      this.loading = false,
      this.height = 52});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.maxFinite,
      child: !loading
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () => onTap(),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : const Center(
              child: SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator()),
            ),
    );
  }
}
