import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/excel_service.dart';
import 'package:tell_sam_admin_panel/Utils/pdf_service.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_report_model.dart';
import 'package:tell_sam_admin_panel/modules/locations/locationController.dart';

class LocationsReportPopup extends StatefulWidget {
  final int locationId;
  final String locationName;
  const LocationsReportPopup(
      {super.key, required this.locationId, required this.locationName});

  @override
  State<LocationsReportPopup> createState() => _LocationsReportPopupState();
}

class _LocationsReportPopupState extends State<LocationsReportPopup> {
  List<String> exportOptions = ['Excel', 'PDF'];
  String? selectedExportOption;
  List<String> dateFilters = [
    'Custom',
    'Today',
    'Yesterday',
    'This month',
    'Past Month'
  ];
  String? selectedFilter;
  DateTime? startDate;
  DateTime? endDate;
  String error = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Generate Reports for ${widget.locationName}'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Container(
        height: 200,
        width: 500,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
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
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedExportOption = value);
                    },
                    borderRadius: BorderRadius.circular(8),
                    isDense: true,
                  ),
                )),
            const SizedBox(
              height: 12,
            ),
            Container(
                height: 48,
                width: 140,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Center(child: Text('Any date')),
                    value: selectedFilter,
                    items: dateFilters
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedFilter = value);
                      onDateFilterApplied(value!);
                    },
                    borderRadius: BorderRadius.circular(8),
                    isDense: true,
                  ),
                )),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
            const Spacer(),
            PrimaryButton(
                loading: isLoading,
                onTap: () {
                  if (selectedExportOption == null || selectedFilter == null) {
                    setState(() {
                      error = 'Select all options to continue.';
                    });
                    return;
                  }
                  getLocationReportsData();
                },
                title: 'Generate')
          ],
        ),
      ),
    );
  }

  onDateFilterApplied(String filterType) {
    if (filterType == 'Custom') {
      openDateRangePicker();
    } else {
      Map<String, DateTime> range = Utils.getDateRange(filterType);
      startDate = range['start'];
      endDate = range['end'];
      setState(() {});
    }
  }

  openDateRangePicker() async {
    DateTime now = DateTime.now();
    DateTimeRange? ranges = await showDateRangePicker(
        context: context,
        firstDate: DateTime(now.year - 1, now.month, now.day),
        lastDate: DateTime(now.year, 12, now.day),
        currentDate: now);

    if (ranges != null) {
      startDate = ranges.start;
      endDate = ranges.end;
    }
  }

  getLocationReportsData() async {
    setState(() {
      isLoading = true;
    });
    List<LocationReportData>? data = await getReportData(
        widget.locationId, startDate!.toString(), endDate!.toString());
    setState(() {
      isLoading = false;
    });
    if (data != null) {
      await exportReport(selectedExportOption!, data);
      Navigator.pop(context);
    }
  }

  exportReport(String type, List<LocationReportData> records) async {
    if (type == 'Excel') {
      ExcelService service = ExcelService(widget.locationName);
      service.initForLocationData();
      service.createAndSaveLocationReport(records);
    } else {
      PdfService service = PdfService();
      await service.init();
      service.makePdfForLocationData(context, records, widget.locationName);
    }
  }
}

Future showLocationReportPopup(context, int locationId, String locationName) async {
  await showDialog(
      context: context,
      builder: (context) => LocationsReportPopup(
          locationId: locationId, locationName: locationName));
}
