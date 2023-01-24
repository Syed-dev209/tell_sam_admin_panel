import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_record_model.dart';
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

  loadData() {
    getStaffRecords(widget.staffId).then((value) {
      staffRecordsStream.add(value);
      return value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    staffRecordsStream = StreamController<List<StaffRecord>?>.broadcast();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.name ?? 'N/A',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
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
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No Records found'),
                  );
                }
                return DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Color(0xffF3F3F3),
                  ),
                  headingRowHeight: 43.0,
                  dataRowHeight: 50.0,
                  dividerThickness: 0.0,
                  columnSpacing: 20.0,
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Branch')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Clock In')),
                    DataColumn(label: Text('Clock Out')),
                    DataColumn(label: Text('Total Hours')),
                  ],
                  rows: snapshot.data!
                      .map<DataRow>((e) => DataRow(cells: [
                            DataCell(Text("${e.branchName}")),
                            DataCell(Text("${e.date}")),
                            DataCell(Text("${e.clockIn}")),
                            DataCell(Text("${e.clockOut}")),
                            DataCell(Text("${e.totalHrsSpent}"))
                          ]))
                      .toList(),
                );
              })),
    );
  }
}
