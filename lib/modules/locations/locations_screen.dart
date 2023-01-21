import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';
import 'package:tell_sam_admin_panel/modules/locations/locationController.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  late StreamController<List<LocationsModel>?> locationsStream;
  List<DataRow> locationRows = [];
  List<LocationsModel> allLocations = [];
  bool addingNew = false, saveLoading = false;

  loadData() {
    getAllLocations().then((value) {
      locationsStream.add(value);
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    locationsStream = StreamController<List<LocationsModel>?>.broadcast();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<LocationsModel>?>(
            stream: locationsStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No Locations found'),
                );
              }
              allLocations = [...snapshot.data!];
              if (!addingNew) {
                getLocationRow(allLocations, locationRows);
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
                        onTap: () => addLocationRow(allLocations, locationRows),
                        height: 44,
                        title: '+ Add new Location',
                        width: size.width * 0.15,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Color(0xffF3F3F3),
                          ),
                          headingRowHeight: 43.0,
                          dataRowHeight: 50.0,
                          dividerThickness: 0.0,
                          columnSpacing: 20.0,
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(
                              label: Text('ID'),
                            ),
                            DataColumn(
                              label: Text('Branch Name'),
                            ),
                            DataColumn(label: Text('Action'))
                          ],
                          rows: locationRows),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  getLocationRow(List<LocationsModel> locations, List<DataRow> locationRows) {
    for (var e in locations) {
      locationRows.add(DataRow(cells: [
        DataCell(
          Text("${e.locationId}"),
        ),
        DataCell(
          Text("${e.locationName}"),
        ),
        DataCell(getLocationActions())
      ]));
    }
  }

  getLocationActions() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(FeatherIcons.trash),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(FeatherIcons.edit),
        )
      ],
    );
  }

  addLocationRow(
      List<LocationsModel> allLocations, List<DataRow> locationRows) {
    if (addingNew) {
      return true;
    }
    allLocations.sort((a, b) => a.locationId!.compareTo(b.locationId!));
    int highest = allLocations.last.locationId! + 1;
    String branchName = '';
    locationRows.add(
      DataRow(
        cells: [
          DataCell(
            Text('$highest'),
          ),
          DataCell(TextField(
            onChanged: (value) {
              branchName = value;
            },
          )),
          DataCell(Row(
            children: [
              TextButton(
                onPressed: () => saveLocation(branchName),
                child: saveLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Save'),
              ),
               TextButton(
                  onPressed: () {
                    locationRows.clear();
                    addingNew = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'))
            ],
          ))
        ],
      ),
    );
    setState(() {
      addingNew = true;
    });
  }

  saveLocation(String name) async {
    if (name.isEmpty) {
      Utils.showToast('Name is required');
      return;
    }
    setState(() {
      saveLoading = true;
    });
    bool result = await addLocation(name);
    setState(() {
      saveLoading = false;
      addingNew = false;
      locationRows.clear();
    });
    if (result) {
      locationsStream.addError('Loading');
      loadData();
    }
  }
}
