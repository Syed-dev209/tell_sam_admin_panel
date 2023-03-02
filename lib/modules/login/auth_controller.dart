import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tell_sam_admin_panel/Utils/dio_service.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/constants/network_constants.dart';

int adminId = 0;

Future<bool> loginAdmin(String username, String password) async {
  final firestore = FirebaseFirestore.instance;
  try {
    final data =
        await firestore.collection('enable').doc('wa3oxqtjaaPzpatEEFix').get();
    Map<String, dynamic>? enableData = data.data();
    log(enableData.toString());
    if (enableData!['allow']) {
      var response = await DioService.post(APIS.login,
          body: {"admin_username": username, "admin_password": password});
      bool loggedIn = response.data['status'] == 1;
      if (!loggedIn) {
        Utils.showToast('Invalid username or password', AlertType.error);
        return false;
      } else {
        Utils.showToast('Logged in', AlertType.success);
        adminId = response.data['data']['admin_id'];
        return loggedIn;
      }
    } else {
      return false;
    }
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    log(e.toString());
    return false;
  }
}

Future<bool> changeAdminPassword(String oldPass, String newPass) async {
  try {
    Map<String, dynamic> body = {
      "admin_id": adminId,
      "current_password": oldPass,
      "new_password": newPass
    };
    log(body.toString());
    var response = await DioService.post(APIS.changePassword, body: body);
    bool check = response.data['status'] == 1;
    if (check) {
      Utils.showToast("Password changed", AlertType.success);
      return check;
    } else {
      Utils.showToast(response.data["message"], AlertType.error);
      return check;
    }
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    return false;
  }
}
