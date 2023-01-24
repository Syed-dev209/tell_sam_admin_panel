import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tell_sam_admin_panel/Utils/global_nav.dart';
import 'package:tell_sam_admin_panel/Utils/validators.dart';
import 'package:tell_sam_admin_panel/common/custom_text_field.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/staff/Model/staff_model.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_controller.dart';

class StaffEditPopup {
  static Future show(context, StaffModel staff) async {
    TextEditingController name = TextEditingController(text: staff.staffName);
    TextEditingController locationID =
        TextEditingController(text: staff.staffId.toString());
    TextEditingController pin = TextEditingController(text: staff.pin);
    GlobalKey<FormState> key = GlobalKey<FormState>();
    return await showDialog(
        context: context,
        builder: (context) {
          bool buttonLoading = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Edit Staff details'),
              content: SizedBox(
                height: 300,
                width: 500,
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: name,
                        hintText: 'Enter name',
                        validator: Validators.requiredValidator,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: locationID,
                        hintText: 'Enter Branch ID',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField(
                        controller: pin,
                        hintText: 'Enter PIN',
                        validator: Validators.lengthValidator,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      PrimaryButton(
                        onTap: () async {
                          if (key.currentState!.validate()) {
                            setState(() {
                              buttonLoading = true;
                            });
                            await editStaff(staff.staffId!, name.text,
                                int.parse(locationID.text), pin.text);
                            Navigator.pop(context);
                          }
                        },
                        title: 'Update',
                        loading: buttonLoading,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
