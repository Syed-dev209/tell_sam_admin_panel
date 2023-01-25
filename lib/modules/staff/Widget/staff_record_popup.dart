import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/staff/Widget/custom_time_picker.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_controller.dart';

class StaffRecordPopup {
  static Future show(context, int? recordId, String? dateTime, String rawDate,
      int locationId, Entry type, int staffId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return EditStaffPopupBody(
              recordId: recordId,
              dateTime: dateTime,
              rawDate: rawDate,
              staffId: staffId,
              locationId: locationId,
              type: type,
            );
          });
        });
  }
}

class EditStaffPopupBody extends StatefulWidget {
  final int? recordId;
  final String? dateTime;
  final String rawDate;
  final int locationId;
  final Entry type;
  final int staffId;
  const EditStaffPopupBody(
      {super.key,
      required this.dateTime,
      required this.rawDate,
      required this.recordId,
      required this.locationId,
      required this.staffId,
      required this.type});

  @override
  State<EditStaffPopupBody> createState() => _EditStaffPopupBodyState();
}

class _EditStaffPopupBodyState extends State<EditStaffPopupBody> {
  DateTime? updatedTime;
  bool buttonLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('Edit Time'),
      content: SizedBox(
        height: 230,
        width: 500,
        child: Column(
          children: [
            CustomTimePicker(
                initialDate: widget.dateTime != null
                    ? DateTime.parse(widget.dateTime!)
                    : DateTime.parse(widget.rawDate),
                onDateChange: (newTime) {
                  print(newTime);
                  updatedTime = newTime;
                }),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
                loading: buttonLoading,
                onTap: () =>
                    widget.dateTime != null ? editRecord() : addNewRecord(),
                title: 'Save')
          ],
        ),
      ),
    );
  }

  editRecord() async {
    setState(() {
      buttonLoading = true;
    });
    bool check =
        await editClockInClockOutTime(updatedTime.toString(), widget.recordId!);
    setState(() {
      buttonLoading = false;
    });
    Navigator.pop(context, check);
  }

  addNewRecord() async {
    setState(() {
      buttonLoading = true;
    });

    bool check = await clockInOrOut(
        context, widget.staffId, widget.locationId, widget.type, updatedTime!);
    setState(() {
      buttonLoading = false;
    });
    Navigator.pop(context, check);
  }
}
