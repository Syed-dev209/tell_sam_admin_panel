import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/common/location_drop_down.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';
import 'package:tell_sam_admin_panel/modules/locations/locationController.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_model.dart';
import 'package:tell_sam_admin_panel/modules/staff/Widget/staff_edit_popup.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_controller.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_records.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  late StreamController<List<StaffModel>?> staffStream;
  List<DataRow> staffRows = [];
  List<StaffModel> allStaff = [];
  bool isAddingNew = false, saveLoading = false;
  List<LocationsModel> allLocations = [];
  loadData() {
    getAllStaffMembers().then((value) {
      staffStream.add(value);
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

  refreshState() {
    allStaff.clear();
    staffRows.clear();
    staffStream.addError('Loading');
    loadData();
  }

  @override
  void initState() {
    super.initState();
    staffStream = StreamController<List<StaffModel>?>.broadcast();
    loadData();
    loadLocations();
  }

  @override
  void dispose() {
    staffStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<StaffModel>?>(
            stream: staffStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No staff members found'),
                );
              }
              allStaff = [...snapshot.data!];
              if (!isAddingNew) {
                getStaffRows(allStaff, staffRows);
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Staff members',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      PrimaryButton(
                        onTap: () => addNewStaffRow(allStaff, staffRows),
                        height: 44,
                        title: '+ Add new staff',
                        width: size.width * 0.15,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: SizedBox(
                      width: size.width,
                      child: SingleChildScrollView(
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
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Location')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: staffRows,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  getStaffRows(List<StaffModel> allStaff, List<DataRow> staffRow) {
    for (var e in allStaff) {
      staffRows.add(DataRow(
          onSelectChanged: (value) {
            NavigationServices.pushScreen(StaffRecordsScreen(
              staffId: e.staffId!,
              name: e.staffName ?? "N?a",
            ));
          },
          cells: [
            DataCell(Text("${e.staffId}")),
            DataCell(Text("${e.staffName}")),
            DataCell(Text("${e.LocationName}")),
            DataCell(staffAction(
                onEdit: () async =>
                    await StaffEditPopup.show(context, e, allLocations)
                        .then((value) {
                      if (value != null && value) {
                        Future.delayed(Duration(seconds: 2), () {
                          refreshState();
                        });
                      }
                    }),
                onDelete: () => deleteStaffAction(e))),
          ]));
    }
  }

  deleteStaffAction(StaffModel model) async {
    await deleteStaff(model.staffId!);
    refreshState();
  }

  staffAction({required Function onEdit, required Function onDelete}) {
    return Row(
      children: [
        IconButton(
          onPressed: () => onDelete(),
          icon: Icon(FeatherIcons.trash),
        ),
        IconButton(
          onPressed: () => onEdit(),
          icon: Icon(FeatherIcons.edit),
        )
      ],
    );
  }

  addNewStaffRow(List<StaffModel> allStaff, List<DataRow> staffRow) {
    if (isAddingNew) {
      return;
    }
    allStaff.sort((a, b) => a.staffId!.compareTo(b.staffId!));
    int highest = allStaff.last.staffId! + 1;
    String memberName = '';
    String locationId = '';
    String pin = '';
    staffRows.insert(
      0,
      DataRow(
        cells: [
          DataCell(
            Text('$highest'),
          ),
          DataCell(TextField(
            decoration: const InputDecoration(hintText: 'Enter name'),
            onChanged: (value) {
              memberName = value;
            },
          )),
          DataCell(Row(
            children: [
              Flexible(
                  child: LocationDropDown(
                      locations: allLocations,
                      onChange: (value) {
                        locationId = value.locationId.toString();
                      })),
              const SizedBox(
                width: 4,
              ),
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Enter PIN'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    pin = value;
                  },
                ),
              ),
            ],
          )),
          DataCell(Row(
            children: [
              TextButton(
                onPressed: () => saveStaff(memberName, locationId, pin),
                child: saveLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Save'),
              ),
              TextButton(
                  onPressed: () {
                    staffRows.clear();
                    isAddingNew = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'))
            ],
          ))
        ],
      ),
    );
    setState(() {
      isAddingNew = true;
    });
  }

  saveStaff(String name, String locationId, String pin) async {
    if (name.isEmpty || locationId.isEmpty || pin.isEmpty) {
      Utils.showToast('All Fields are mandatory', AlertType.warning);
      return;
    }
    setState(() {
      saveLoading = true;
    });
    bool result = await addStaff(name, int.parse(locationId), pin);
    setState(() {
      saveLoading = false;
      isAddingNew = false;
      staffRows.clear();
    });
    if (result) {
      staffStream.addError("Loading");
      loadData();
    }
  }
}
