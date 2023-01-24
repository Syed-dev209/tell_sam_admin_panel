import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/validators.dart';
import 'package:tell_sam_admin_panel/common/custom_text_field.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';
import 'package:tell_sam_admin_panel/modules/locations/locationController.dart';

class LocationEdit {
  static Future show(context, LocationsModel model) async {
    await showDialog(
        context: context,
        builder: (context) {
          bool buttonLoading = false;
          TextEditingController branchName =
              TextEditingController(text: model.locationName);
          GlobalKey<FormState> key = GlobalKey<FormState>();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('Edit Branch'),
              content: Container(
                height: 200,
                width: 500,
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: branchName,
                        hintText: 'Enter branch name',
                        validator: Validators.requiredValidator,
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
                            await editLocation(
                                model.locationId!, branchName.text);
                            setState(() {
                              buttonLoading = false;
                            });
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
