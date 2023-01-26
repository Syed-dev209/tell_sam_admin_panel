class StaffModel {
/*
{
  "staff_id": 1,
  "staff_loc_id": 1,
  "staff_name": "James"
} 
*/

  int? staffId;
  int? staffLocId;
  String? staffName, pin, LocationName;
  bool isEditMode = false;

  StaffModel({this.staffId, this.staffLocId, this.staffName, this.pin});
  StaffModel.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id']?.toInt();
    staffLocId = json['staff_loc_id']?.toInt();
    staffName = json['staff_name']?.toString();
    pin = json['staff_pin']?.toString();
    LocationName = json['location_name'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['staff_id'] = staffId;
    data['staff_loc_id'] = staffLocId;
    data['staff_name'] = staffName;
    return data;
  }
}
