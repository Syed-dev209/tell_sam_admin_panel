import 'package:excel/excel.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_report_model.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_record_model.dart';

class ExcelService {
  final String staffName;
  ExcelService(this.staffName);
  late Excel excel;
  late Sheet sheet;

  init(int totalHrsWorked) {
    excel =
        Excel.createExcel(); //create empty 1 emptyb sheet name as : "Sheet1"
    sheet = excel['Sheet1'];
    List<String> staffDetails = ['Name', staffName];
    List<String> totalHrsDetail = ['Total Hrs', totalHrsWorked.toString()];

    List<String> columnName = [
      'Location',
      'Date',
      'Clock In',
      'Clock Out',
      'Total Hours'
    ];
     sheet.insertRowIterables(staffDetails, 0);
     sheet.insertRowIterables(totalHrsDetail, 1);
    sheet.insertRowIterables(columnName, 2);
   
  }

  initForLocationData() {
    excel =
        Excel.createExcel(); //create empty 1 emptyb sheet name as : "Sheet1"
    sheet = excel['Sheet1'];
    List<String> columnName = [
      'Name',
      'Total Hours',
    ];
    sheet.insertRowIterables(columnName, 0);
  }

  createAndSave(List<StaffRecord> records) {
    for (int i = 0; i < records.length; i++) {
      StaffRecord e = records[i];
      List data = [
        e.LocationName,
        e.date,
        e.clockIn,
        e.clockOut,
        e.totalHrsSpent
      ];
      sheet.insertRowIterables(data, i + 3);
    }

    var fileBytes = excel.save(fileName: "$staffName.xlsx");
  }

  createAndSaveLocationReport(List<LocationReportData> records) {
    for (int i = 0; i < records.length; i++) {
      LocationReportData e = records[i];
      List data = [e.staffName, e.totalHours];
      sheet.insertRowIterables(data, i + 1);
    }

    var fileBytes = excel.save(fileName: "$staffName.xlsx");
  }
}
