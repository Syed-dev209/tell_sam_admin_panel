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
        MotionToast.warning(
                title: const Text("Warning"), description: Text(message))
            .show(NavigationServices.navigationKey.currentContext!);
        break;
      case AlertType.error:
        MotionToast.error(
                title: const Text("Error"), description: Text(message))
            .show(NavigationServices.navigationKey.currentContext!);
        break;
    }
  }

  static String formatDate(String? dateTime) {
    try {
      if (dateTime == null) return '-';
      DateTime toParse = DateTime.parse(dateTime);
      DateFormat format = DateFormat('dd MMM yy');
      return format.format(toParse);
    } catch (e) {
      return '-';
    }
  }

  static String formatTime(String? dateTime) {
    try {
      if (dateTime == null) return '-';
      DateTime toParse = DateTime.parse(dateTime);
      return DateFormat.Hm().format(toParse);
    } catch (e) {
      return '-';
    }
  }

  static String formatDateTime(String? dateTime) {
    try {
      if (dateTime == null) return '-';
      DateTime toParse = DateTime.parse(dateTime);
      DateFormat format = DateFormat('dd MMM yy hh:mm');
      return format.format(toParse);
    } catch (e) {
      return '-';
    }
  }

  static String calculateHours(String clockIn, String clockOut) {
    try {
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
    } catch (e) {
      return '-';
    }
  }

  static Map<String, DateTime> getDateRange(String filterType) {
    Map<String, DateTime> range = {};
    DateTime now = DateTime.now();
    DateTime currentDate = now.subtract(Duration(
        hours: now.hour,
        minutes: now.minute,
        seconds: now.second,
        milliseconds: now.millisecond,
        microseconds: now.microsecond));

    if (filterType == 'Today') {
      range['start'] = currentDate;
      range['end'] =
          currentDate.add(const Duration(minutes: 59, hours: 23, seconds: 59));
    } else if (filterType == 'Yesterday') {
      DateTime yesterday = currentDate.subtract(const Duration(days: 1));
      range['start'] = (yesterday);
      range['end'] =
          (yesterday.add(const Duration(minutes: 59, hours: 23, seconds: 59)));
    } else if (filterType == 'This month') {
      range['start'] =
          (DateTime(currentDate.year, currentDate.month, 1, 0, 0, 0));
      range['end'] =
          (DateTime(currentDate.year, currentDate.month + 1, 23, 59, 0, 0));
    } else if (filterType == 'Past Month') {
      range['start'] =
          (DateTime(currentDate.year, currentDate.month - 1, 1, 0, 0, 0));
      range['end'] =
          (DateTime(currentDate.year, currentDate.month, 0, 23, 59, 0, 0));
    }
    return range;
  }
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  // String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
}
