import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/Utils/validators.dart';
import 'package:tell_sam_admin_panel/common/custom_text_field.dart';
import 'package:tell_sam_admin_panel/common/primary_button.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';
import 'package:tell_sam_admin_panel/modules/locations/locationController.dart';

import '../../../Utils/global_nav.dart';

class LocationEdit {
  static Future show(context, LocationsModel model) async {
    return await showDialog(
        context: context,
        builder: (context2) {
          return EditLocation(model);
        });
  }
}

class EditLocation extends StatefulWidget {
  const EditLocation(this.model, {Key? key}) : super(key: key);
  final LocationsModel model;
  @override
  State<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  bool buttonLoading = false;
  TextEditingController LocationName = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    LocationName.text = widget.model.locationName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Edit Location'),
      content: Container(
        height: 200,
        width: 500,
        child: Form(
          key: key,
          child: Column(
            children: [
              CustomTextField(
                controller: LocationName,
                hintText: 'Enter Location name',
                label: 'Location Name',
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
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop(true);
                    bool check = await editLocation(
                        widget.model.locationId!, LocationName.text, context);
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
  }
}
