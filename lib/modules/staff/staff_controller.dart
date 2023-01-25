import 'dart:developer';

import 'package:tell_sam_admin_panel/Utils/dio_service.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/constants/network_constants.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_model.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_record_model.dart';

enum Entry { clockIn, clockOut }

Future<List<StaffModel>?> getAllStaffMembers() async {
  try {
    var response = await DioService.get(APIS.allStaff);
    List<StaffModel> staffMembers = [];
    for (var i in response.data['data']) {
      staffMembers.add(StaffModel.fromJson(i));
    }
    return staffMembers;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
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
    Utils.showToast(response.data['message'].toString(), AlertType.success);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
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
    Utils.showToast(response.data['message'], AlertType.success);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    return false;
  }
}

Future<bool> deleteStaff(int staffId) async {
  try {
    Map<String, dynamic> body = {"staff_id": staffId};
    var response = await DioService.post(APIS.deleteStaff, body: body);
    Utils.showToast(response.data['message'], AlertType.success);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
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
      String rawDate = data.first["record_timestamp"]?.substring(0, 10);
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
            branchId: data.first["location_id"],
            date: clockInDate,
            clockIn: Utils.formatTime(clockInDateTime),
            rawDate: rawDate,
            rawClockIn: clockInDateTime,
            clockInRecordId: clockInDetails["record_id"],
            clockOutRecordId:
                clockOutDetails != null ? clockOutDetails["record_id"] : null,
            clockOut: clockOutDetails != null
                ? Utils.formatTime(clockOutDetails["record_timestamp"])
                : '-',
            rawClockOut: clockOutDetails != null
                ? clockOutDetails["record_timestamp"]
                : null,
            totalHrsSpent: Utils.calculateHours(
                clockInDateTime,
                clockOutDetails != null
                    ? clockOutDetails["record_timestamp"]
                    : '')),
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
    Utils.showToast(e.toString(), AlertType.error);
    return null;
  }
}

Future<bool> editClockInClockOutTime(String dateTime, int recordId) async {
  try {
    Map<String, dynamic> body = {
      "record_id": recordId,
      "record_timestamp": dateTime
    };
    var response = await DioService.post(APIS.editStaffRecord, body: body);
    Utils.showToast(response.data['message'].toString(), AlertType.success);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    return false;
  }
}

Future clockInOrOut(
    context, int staffId, int locationId, Entry type, DateTime current) async {
  try {
    Map<String, dynamic> data = {
      "staff_id": staffId,
      "location_id": locationId,
      "type": type == Entry.clockIn ? 'clockin' : 'clockout',
      "timestamp": current.toString()
    };
    var response = await DioService.post(APIS.clock, body: data);

    Utils.showToast(response.data['message'].toString(), AlertType.success);
    return response.data['status'] == 1;
  } catch (e) {
    log(e.toString());
    Utils.showToast(e.toString(), AlertType.success);
    return false;
  }
}
