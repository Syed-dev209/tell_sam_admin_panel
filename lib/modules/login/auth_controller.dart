import 'dart:developer';

import 'package:tell_sam_admin_panel/Utils/dio_service.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/constants/network_constants.dart';

Future<bool> loginAdmin(String username, String password) async {
  try {
    var response = await DioService.post(APIS.login,
        body: {"admin_username": username, "admin_password": password});
    bool loggedIn = response.data['status'] == 1;
    if (!loggedIn) {
      Utils.showToast('Invalid username or password');
      return false;
    }
    return loggedIn;
  } catch (e) {
    Utils.showToast(e.toString());
    log(e.toString());
    return false;
  }
}
