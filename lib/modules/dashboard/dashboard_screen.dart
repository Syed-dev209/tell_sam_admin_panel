import 'package:flutter/material.dart';
import 'package:ready/ready.dart';
import 'package:tell_sam_admin_panel/modules/locations/locations_screen.dart';
import 'package:tell_sam_admin_panel/modules/staff/staff_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ReadyDashboard(
      iconsWhenCollapsedInDesktop:true,
      items: [
        DashboardItem(
            label: 'Staff',
            id: 'staff',
            builder: () {
              return const StaffScreen();
            },
            icon: const Icon(Icons.dashboard)),
            DashboardItem(
            label: 'Branches',
            id: 'locations',
            builder: () {
              return const LocationsScreen();
            },
            icon: const Icon(Icons.location_searching_sharp)),
      ],
    );
  }
}
