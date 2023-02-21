import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/excel_service.dart';
import 'package:tell_sam_admin_panel/Utils/extensions.dart';
import 'package:tell_sam_admin_panel/Utils/pdf_service.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';
import 'package:tell_sam_admin_panel/modules/locations/locationController.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_record_model.dart';
import 'package:tell_sam_admin_panel/modules/staff/Widget/filter_widget.dart';
import 'package:tell_sam_admin_panel/modules/staff/Widget/staff_record_popup.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_controller.dart';

class StaffRecordsScreen extends StatefulWidget {
  final int staffId;
  final String name;
  const StaffRecordsScreen(
      {super.key, required this.staffId, required this.name});

  @override
  State<StaffRecordsScreen> createState() => _StaffRecordsScreenState();
}

class _StaffRecordsScreenState extends State<StaffRecordsScreen> {
  late StreamController<List<StaffRecord>?> staffRecordsStream;
  late List<StaffRecord> allRecords = [];
  List<LocationsModel> allLocations = [];
  List<String> exportOptions = ['Excel', 'PDF'];
  String? selectedExportOption;

  loadData() {
    getStaffRecords(widget.staffId).then((value) {
      staffRecordsStream.add(value);
      if (value != null) {
        allRecords = [...value];
      }
      return value;
    });
  }

  loadLocations() {
    getAllLocations().then((value) {
      if (value != null) {
        allLocations = [...value];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    staffRecordsStream = StreamController<List<StaffRecord>?>.broadcast();
    loadLocations();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.name,
          ),
        ),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<List<StaffRecord>?>(
              stream: staffRecordsStream.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Text('No Records found'),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 48,
                        width: 140,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Center(child: Text('Export')),
                            value: selectedExportOption,
                            items: exportOptions
                                .map<DropdownMenuItem<String>>((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedExportOption = value);
                              exportReport(value!, snapshot.data!,
                                  calculateTotalHours(snapshot.data!));
                            },
                            borderRadius: BorderRadius.circular(8),
                            isDense: true,
                          ),
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text('Filters'),
                    FilterWidget(
                      allLocations: allLocations,
                      onFilterApplied: applyFilter,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Total Hours: ${calculateTotalHours(snapshot.data!)}",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    snapshot.data!.isNotEmpty
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: double.maxFinite,
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                    (states) =>
                                        const Color.fromARGB(66, 35, 35, 35),
                                  ),
                                  headingRowHeight: 43.0,
                                  dataRowHeight: 50.0,
                                  dividerThickness: 0.0,
                                  columnSpacing: 20.0,
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(label: Text('Location')),
                                    DataColumn(label: Text('Date')),
                                    DataColumn(label: Text('Clock In')),
                                    DataColumn(label: Text('Clock Out')),
                                    DataColumn(label: Text('Total Hours')),
                                  ],
                                  rows: snapshot.data!
                                      .map<DataRow>((e) => DataRow(cells: [
                                            DataCell(Text("${e.LocationName}")),
                                            DataCell(Text("${e.date}")),
                                            DataCell(Tooltip(
                                              message: 'Edit clock in time',
                                              child: TextButton(
                                                  onPressed: () =>
                                                      openEditTimeBottomSheet(
                                                          e.clockInRecordId,
                                                          e.rawClockIn,
                                                          e.rawDate!,
                                                          Entry.clockIn,
                                                          e.LocationId!,
                                                          widget.staffId),
                                                  child: Text("${e.clockIn}",
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.white))),
                                            )),
                                            DataCell(Tooltip(
                                              message: 'Edit clock out time',
                                              child: TextButton(
                                                  onPressed: () =>
                                                      openEditTimeBottomSheet(
                                                          e.clockOutRecordId,
                                                          e.rawClockOut,
                                                          e.rawDate!,
                                                          Entry.clockOut,
                                                          e.LocationId!,
                                                          widget.staffId),
                                                  child: Text(
                                                    "${e.clockOut}",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            )),
                                            DataCell(Text("${e.totalHrsSpent}"))
                                          ]))
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        : const Text('No Records Found'),
                  ],
                );
              })),
    );
  }

  openEditTimeBottomSheet(int? recordId, String? rawDateTime, String rawDate,
      Entry type, int locationId, int staffId) async {
    bool? check = await StaffRecordPopup.show(
        context, recordId, rawDateTime, rawDate, locationId, type, staffId);
    if (check != null && check) {
      staffRecordsStream.addError('Loading');
      loadData();
    }
  }

  calculateTotalHours(List<StaffRecord> allRecords) {
    int hours = 0;
    for (var record in allRecords) {
      if (record.totalHrsSpent != null && record.totalHrsSpent != '-') {
        String parsedHour = record.totalHrsSpent!.substring(0, 2);
        hours += int.tryParse(parsedHour) ?? 0;
      }
    }

    return hours;
  }

  applyFilter(
      DateTime? startdate, DateTime? endDate, LocationsModel? location) {
    List<StaffRecord> filteredRecords = [];

    if (startdate == null && endDate == null && location == null) {
      staffRecordsStream.add(allRecords);
      return;
    }

    if (location != null && startdate != null && endDate != null) {
      log('Location to filter${location.locationId}');
      log("Start Date==> $startdate");
      log("End Date==> $endDate");
      filteredRecords = [
        ...allRecords
            .where((element) =>
                element.LocationId == location.locationId &&
                (DateTime.tryParse(element.rawDate!)
                        .isBetween(startdate, endDate) ??
                    false))
            .toList()
      ];
    } else if (location != null) {
      log('Location to filter${location.locationId}');
      filteredRecords = [
        ...allRecords
            .where((element) => element.LocationId == location.locationId)
            .toList()
      ];
    } else if (startdate != null && endDate != null) {
      log("Start Date==> $startdate");
      log("End Date==> $endDate");
      filteredRecords = [
        ...allRecords
            .where((element) =>
                DateTime.tryParse(element.rawDate!)
                    .isBetween(startdate, endDate) ??
                false)
            .toList()
      ];
    }
    staffRecordsStream.add(filteredRecords);
  }

  exportReport(String type, List<StaffRecord> records, int totalHrs) async {
    if (type == 'Excel') {
      ExcelService service = ExcelService(widget.name);
      service.init();
      service.createAndSave(records);
    } else {
      PdfService service = PdfService();
      await service.init();
      service.makePdf(context, widget.name, totalHrs, records);
    }
  }
}
