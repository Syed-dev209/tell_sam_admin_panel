import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tell_sam_admin_panel/Utils/utils.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(DateTime) onDateChange;
  final DateTime initialDate;
  const CustomTimePicker(
      {super.key, required this.onDateChange, required this.initialDate});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late DateTime selectedDateTime;

  pickTime() async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: selectedDateTime.hour, minute: selectedDateTime.minute),
    );
    print(pickedTime);
    if (pickedTime != null) {
      selectedDateTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {});
      widget.onDateChange(selectedDateTime);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        child: InkWell(
          onTap: () => pickTime(),
          child: Ink(
            height: 52,
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4), blurRadius: 8, color: Colors.black)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Utils.formatTime(selectedDateTime.toString())),
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  FeatherIcons.clock,
                  color: Colors.white,
                )
              ],
            ),
            // child: CupertinoTheme(
            //   data: const CupertinoThemeData(
            //       textTheme: CupertinoTextThemeData(
            //           dateTimePickerTextStyle: TextStyle(
            //               fontSize: 24,
            //               fontWeight: FontWeight.w800,
            //               color: Colors.white))),
            //   child: CupertinoDatePicker(
            //     key: UniqueKey(),
            //     onDateTimeChanged: (DateTime newDateTime) {
            //       // update the date
            //       widget.onDateChange(newDateTime);
            //     },
            //     initialDateTime: widget.initialDate,
            //     use24hFormat: true,
            //     mode: CupertinoDatePickerMode.time,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
