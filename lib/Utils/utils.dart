import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';

enum AlertType { success, error, warning }

class Utils {
  static showToast(String message, AlertType type) {
    switch (type) {
      case AlertType.success:
        MotionToast.success(
          title: const Text("Success"),
          description: Text(message),
        ).show(NavigationServices.navigationKey.currentContext!);
        break;
      case AlertType.warning:
        MotionToast.warning(title: const Text("Warning"), description: Text(message))
            .show(NavigationServices.navigationKey.currentContext!);
        break;
      case AlertType.error:
        MotionToast.error(title: const Text("Error"), description: Text(message))
            .show(NavigationServices.navigationKey.currentContext!);
        break;
    }
  }

  static String formatDate(String dateTime) {
    DateTime toParse = DateTime.parse(dateTime);
    DateFormat format = DateFormat('dd MMM yy');
    return format.format(toParse);
  }

  static String formatTime(String dateTime) {
    DateTime toParse = DateTime.parse(dateTime);
    return DateFormat.Hm().format(toParse);
  }

  static String calculateHours(String clockIn, String clockOut) {
    if (clockIn.isEmpty || clockOut.isEmpty) {
      return '-';
    }
    log("=============");
    log(clockIn);
    log(clockOut);
    log("=============");

    DateTime inTime = DateTime.parse(clockIn);
    DateTime out = DateTime.parse(clockOut);
    Duration sessionTime = out.difference(inTime);
    return printDuration(sessionTime);
  }
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  // String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
}
