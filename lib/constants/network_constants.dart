class APIS {
  static const String accessToken = 'secretTokenForTellSam';
  static const Map<String, dynamic> header = {
    'x-access-token': accessToken,
    'Accept': 'application/json',
  };
  static const String baseUrl = 'https://www.codewithmemes.com/';
  static const String login = 'admin/login';
  static const String allStaff = 'staffs';
  static const String addStaff = 'staff/add';
  static const String staffRecords = 'admin/staff/records';
  static const String allLocations = 'locations';
  static const String addLocation = 'locations/add';
}
