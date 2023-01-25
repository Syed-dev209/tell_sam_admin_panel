import 'package:flutter/material.dart';
import 'package:tell_sam_admin_panel/modules/locations/Model/location_model.dart';

class LocationDropDown extends StatefulWidget {
  final List<LocationsModel> locations;
  final ValueChanged<LocationsModel> onChange;
  final int? selectedLocation;
  final double? width;
  final bool showDecoration;
  const LocationDropDown(
      {super.key,
      required this.locations,
      required this.onChange,
      this.width,
      this.selectedLocation,
      this.showDecoration = false});

  @override
  State<LocationDropDown> createState() => _LocationDropDownState();
}

class _LocationDropDownState extends State<LocationDropDown> {
  LocationsModel? selectedModel;

  @override
  void initState() {
    super.initState();
    if (widget.selectedLocation != null) {
      selectedModel = widget.locations.firstWhere(
          (element) => element.locationId == widget.selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: DropdownButtonFormField<LocationsModel>(
        value: selectedModel,
        hint: const Text('Select Branch'),
        items: widget.locations
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.locationName ?? 'N/A'),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedModel = value;
          });
          widget.onChange(selectedModel!);
        },
        decoration: widget.showDecoration
            ? InputDecoration(
                fillColor: Colors.black.withOpacity(0.05),
                filled: true,
                labelText: 'Branch',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none))
            : null,
      ),
    );
  }
}
