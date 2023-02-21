import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';
import 'package:tell_sam_admin_panel/common/location_drop_down.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget(
      {super.key, required this.allLocations, required this.onFilterApplied});
  final List<LocationsModel> allLocations;
  final Function(
          DateTime? startdate, DateTime? endDate, LocationsModel? location)
      onFilterApplied;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  double datePickerHeight = 0;
  DateTime? startDate;
  DateTime? endDate;
  List<String> dateFilters = [
    'Custom',
    'Today',
    'Yesterday',
    'This month',
    'Past Month'
  ];
  String? selectedFilter;
  LocationsModel? selectedLocation;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
              height: 48,
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              child: LocationDropDown(
                  locations: widget.allLocations,
                  showDecoration: true,
                  showLabel: false,
                  onChange: (model) {
                    setState(() => selectedLocation = model);
                    applyFilters();
                  })),
          const SizedBox(
            width: 12,
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
          const SizedBox(
            width: 12,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedFilter = null;
                selectedLocation = null;
              });
              widget.onFilterApplied(null, null, null);
            },
            icon: const Icon(Icons.restore),
          tooltip: 'Reset Filters'
          ),
        ],
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
      applyFilters();
    }
  }

  applyFilters() {
    widget.onFilterApplied(startDate, endDate, selectedLocation);
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
      applyFilters();
    }
  }
}
