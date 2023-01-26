import 'package:flutter/cupertino.dart';
import 'package:tell_sam_admin_panel/Utils/dio_service.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/constants/network_constants.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';

Future<List<LocationsModel>?> getAllLocations() async {
  try {
    var response = await DioService.get(APIS.allLocations);
    List<LocationsModel> allLocations = [];
    for (var i in response.data['data']) {
      allLocations.add(LocationsModel.fromJson(i));
    }
    return allLocations;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    return null;
  }
}

Future<bool> addLocation(String LocationName) async {
  try {
    var response =
        await DioService.post(APIS.addLocation, body: {"name": LocationName});
    Utils.showToast(response.data['message'], AlertType.success);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    return false;
  }
}

Future<bool> editLocation(
    int locationId, String locationName, BuildContext context) async {
  try {
    Map<String, dynamic> body = {
      "location_name": locationName,
      "location_id": locationId.toString()
    };
    var response = await DioService.post(APIS.editLocation, body: body);
    await Utils.showToast(response.data['message'], AlertType.success);

    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    return false;
  }
}

Future<bool> deleteLocation(int locationId) async {
  try {
    Map<String, dynamic> body = {"location_id": locationId};
    var response = await DioService.post(APIS.deleteLocation, body: body);
    Utils.showToast(response.data['message'], AlertType.success);
    return response.data['status'] == 1;
  } catch (e) {
    Utils.showToast(e.toString(), AlertType.error);
    return false;
  }
}
