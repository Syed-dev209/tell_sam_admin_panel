import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/excel_service.dart';
import 'package:tell_sam_admin_panel/Utils/pdf_service.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/allRecords/date_selector.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_report_model.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_controller.dart';

class AllRecords extends StatefulWidget {
  const AllRecords({super.key});

  @override
  State<AllRecords> createState() => _AllRecordsState();
}

class _AllRecordsState extends State<AllRecords> {
  late StreamController<List<LocationReportData>?> controller;
  List<LocationReportData>? preservedData = [];
  DateTime startDate = DateTime(2020, 1, 1);
  DateTime endDate = DateTime(2030, 1, 1);
  String? exportType;

  loadData() {
    getAllStaffRecords(startDate, endDate).then((value) {
      controller.add(value);
      preservedData = [...value!];
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = StreamController<List<LocationReportData>?>();
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
          title: const Text(
            "All Staff Records",
          ),
          centerTitle: false,
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateSelector(onDateFilterApplied: (start, end) {
                    if (start != null && end != null) {
                      startDate = start;
                      endDate = end;
                    } else {
                      startDate = DateTime(2020, 1, 1);
                      endDate = DateTime(2030, 1, 1);
                    }
                    controller.addError("Loading");
                    loadData();
                  }, onExportTypeSelected: (value) {
                    exportType = value;
                  }),
                  PrimaryButton(
                      height: 52,
                      width: 240,
                      onTap: () => exportReport(exportType, preservedData!),
                      title: 'Generate Report')
                ],
              ),
            ),
            StreamBuilder<List<LocationReportData>?>(
              stream: controller.stream,
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

                return snapshot.data!.isNotEmpty
                    ? Expanded(
                        child: SizedBox(
                          width: double.maxFinite,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => const Color.fromARGB(66, 35, 35, 35),
                            ),
                            headingRowHeight: 43.0,
                            dataRowHeight: 50.0,
                            dividerThickness: 0.0,
                            columnSpacing: 20.0,
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(label: Text('Staff name')),
                              DataColumn(label: Text('Total time')),
                            ],
                            rows: snapshot.data!
                                .map<DataRow>((e) => DataRow(cells: [
                                      DataCell(Text("${e.staffName}")),
                                      DataCell(Text(
                                          "${e.totalHours}:${e.totalMinutes}"))
                                    ]))
                                .toList(),
                          ),
                        ),
                      )
                    : const Text('No Records Found');
              },
            ),
          ],
        ),
      ),
    );
  }

  exportReport(String? type, List<LocationReportData> records) async {
    if (type == null) {
      Utils.showToast('Please select export type', AlertType.error);
      return;
    }

    if (type == 'Excel') {
      ExcelService service = ExcelService("All Staff Records");
      service.initForLocationData();
      service.createAndSaveLocationReport(records);
    } else {
      PdfService service = PdfService();
      await service.init();
      service.makePdfForLocationData(context, records, "All Staff Records");
    }
  }
}
