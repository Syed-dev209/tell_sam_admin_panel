import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';

class DateSelector extends StatefulWidget {
  final Function(String? type) onExportTypeSelected;
  final Function(DateTime? startDate, DateTime? endDate) onDateFilterApplied;
  const DateSelector(
      {super.key,
      required this.onDateFilterApplied,
      required this.onExportTypeSelected});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 500,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
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
                    widget.onExportTypeSelected(selectedExportOption);
                  },
                  borderRadius: BorderRadius.circular(8),
                  isDense: true,
                ),
              )),
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
              tooltip: "Restore to defaults",
              onPressed: () {
                startDate = null;
                endDate = null;
                selectedExportOption = null;
                setState(() {});
                widget.onExportTypeSelected(selectedExportOption);
                widget.onDateFilterApplied(startDate, endDate);
              },
              icon: const Icon(Icons.restore))
        ],
      ),
    );
  }

  onDateFilterApplied(String filterType) async {
    if (filterType == 'Custom') {
      await openDateRangePicker();
    } else {
      Map<String, DateTime> range = Utils.getDateRange(filterType);
      startDate = range['start'];
      endDate = range['end'];
      setState(() {});
    }
    widget.onDateFilterApplied(startDate, endDate);
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
}
