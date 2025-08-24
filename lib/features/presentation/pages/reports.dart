import 'package:flutter/material.dart';

import '../widgets/common/app_drawer.dart';

class ReportsManagement extends StatefulWidget {
  const ReportsManagement({super.key});

  @override
  State<ReportsManagement> createState() => _ReportsManagementState();
}

class _ReportsManagementState extends State<ReportsManagement> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
      ),
      drawer: const AppDrawer(currentRoute: '/reports_management'),
      body: const Center(
        child: Text('Reports Management'),
      ),
    );
  }
}
