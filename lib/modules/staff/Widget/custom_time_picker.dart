import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(DateTime) onDateChange;
  final DateTime initialDate;
  const CustomTimePicker({super.key, required this.onDateChange, required this.initialDate});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: CupertinoTheme(
        data: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white))),
        child: CupertinoDatePicker(
          key: UniqueKey(),
          onDateTimeChanged: (DateTime newDateTime) {
            // update the date
            widget.onDateChange(newDateTime);
          },
          initialDateTime: widget.initialDate,
          use24hFormat: true,
          mode: CupertinoDatePickerMode.time,
        ),
      ),
    );
  }
}
