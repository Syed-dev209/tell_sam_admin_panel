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

Future<bool> editStaff(
    int staffId, String name, int locationId, String pin) async {
  try {
    Map<String, dynamic> body = {
      "staff_id": staffId,
      "staff_name": name,
      "staff_loc_id": locationId,
      "staff_pin": pin
    };
    var response = await DioService.post(APIS.editStaff, body: body);
    Utils.showToast(response.data['message']);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString());
    return false;
  }
}

Future<bool> deleteStaff(int staffId) async {
  try {
    Map<String, dynamic> body = {"staff_id": staffId};
    var response = await DioService.post(APIS.deleteStaff, body: body);
    Utils.showToast(response.data['message']);
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
      var clockInDetails = data.first;
      String clockInDateTime = data.first["record_timestamp"];
      String clockInDate = Utils.formatDate(clockInDateTime);
      var clockOutDetails = data.firstWhere(
        (element) =>
            Utils.formatDate(element["record_timestamp"]) == clockInDate &&
            element["record_type"] == "clockout",
        orElse: () => null,
      );
      DateTime clockInTime = DateTime.parse(clockInDateTime);

      staffRecords.add(
        StaffRecord(
            name: data.first["staff_name"],
            branchName: data.first["location_name"],
            date: clockInDate,
            clockIn: Utils.formatTime(clockInDateTime),
            clockInRecordId: clockInDetails["record_id"],
            clockOutRecordId: clockOutDetails!=null? clockOutDetails["record_id"]:null,
            clockOut: clockOutDetails != null
                ? Utils.formatTime(clockOutDetails["record_timestamp"])
                : '-',
            totalHrsSpent: Utils.calculateHours(
                clockInDateTime,
                clockOutDetails != null
                    ? clockOutDetails["record_timestamp"]
                    : DateTime.now().toString())),
      );
      data.removeWhere((element) =>
          element["record_timestamp"] == clockInDateTime &&
          element["record_type"] == "clockin");
      if (clockOutDetails != null) {
        data.removeWhere((element) =>
            element["record_timestamp"] ==
                clockOutDetails["record_timestamp"] &&
            element["record_type"] == "clockout");
      }
    }
    return staffRecords;
  } catch (e) {
    log(e.toString());
    Utils.showToast(e.toString());
    return null;
  }
}
