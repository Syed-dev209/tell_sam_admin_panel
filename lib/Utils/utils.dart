import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';

class Utils {
  static showToast(String message) {
    ScaffoldMessenger.of(NavigationServices.navigationKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static String formatDate(DateTime dateTime) {
    DateFormat format = DateFormat('dd MMM yy');
    return format.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    DateFormat format = DateFormat('hh:mm a');
    return format.format(dateTime);
  }
}
