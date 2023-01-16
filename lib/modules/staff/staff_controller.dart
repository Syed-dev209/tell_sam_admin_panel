import 'dart:developer';

import 'package:tell_sam_admin_panel/Utils/dio_service.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/constants/network_constants.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_model.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_record_model.dart';

Future<List<StaffModel>?> getAllStaffMembers() async {
  try {
    var response = await DioService.get(APIS.allStaff);
    List<StaffModel> staffMembers = [];
    for (var i in response.data['data']) {
      staffMembers.add(StaffModel.fromJson(i));
    }
    return staffMembers;
  } catch (e) {
    Utils.showToast(e.toString());
    return null;
  }
}

Future<bool> addStaff(String name, int locationId, String pin) async {
  try {
    Map<String, dynamic> body = {
      "name": name,
      "location_id": locationId,
      "pin": pin
    };
    var response = await DioService.post(APIS.addStaff, body: body);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString());
    return false;
  }
}

Future<List<StaffRecord>?> getStaffRecords(int staffId) async {
  try {
    var response =
        await DioService.post(APIS.staffRecords, body: {"staff_id": staffId});
    List data = response.data["data"];
    List<StaffRecord> staffRecords = [];
    while (data.isNotEmpty) {
      String clockInDateTime = data.first["record_timestamp"];
      String clockInDate = Utils.formatDate(DateTime.parse(clockInDateTime));
      var clockOutDetails = data.firstWhere(
        (element) =>
            Utils.formatDate(DateTime.parse(element["record_timestamp"])) ==
                clockInDate &&
            element["record_type"] == "clockout",
        orElse: () => null,
      );
      staffRecords.add(
        StaffRecord(
            name: data.first["staff_name"],
            branchName: data.first["location_name"],
            date: clockInDate,
            clockIn: Utils.formatTime(DateTime.parse(clockInDateTime)),
            clockOut: clockOutDetails != null
                ? Utils.formatTime(
                    DateTime.parse(clockOutDetails["record_timestamp"]))
                : '-'),
      );
      data.removeWhere((element) =>
          Utils.formatDate(DateTime.parse(element["record_timestamp"])) ==
          Utils.formatDate(DateTime.parse(clockInDateTime)));
    }
    return staffRecords;
  } catch (e) {
    log(e.toString());
    Utils.showToast(e.toString());
    return null;
  }
}
