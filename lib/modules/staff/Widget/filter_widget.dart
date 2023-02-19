import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/common/location_drop_down.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
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
  List<String> dateFilters = ['Today', 'Yesterday', 'This month', 'Past Month'];
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
                  onChange: (model) =>
                      setState(() => selectedLocation = model))),
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
                  onChanged: (value) => setState(() => selectedFilter = value),
                  borderRadius: BorderRadius.circular(8),
                  isDense: true,
                ),
              )),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.restore),
            tooltip: 'Reset Filters',
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_task),
            tooltip: 'Apply Filters',
          )
        ],
      ),
    );
  }
}
