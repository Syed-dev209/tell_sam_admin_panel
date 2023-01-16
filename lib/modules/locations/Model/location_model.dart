class LocationsModel {
/*
{
  "location_id": 1,
  "location_name": "Branch 1"
} 
*/

  int? locationId;
  String? locationName;

  LocationsModel({
    this.locationId,
    this.locationName,
  });
  LocationsModel.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id']?.toInt();
    locationName = json['location_name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['location_id'] = locationId;
    data['location_name'] = locationName;
    return data;
  }
}
