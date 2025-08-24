
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../cashier/cashier_home_screen.dart';
import '../manager/manager_home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isLoggedIn) {
          return const LoginScreen();
        }
        if (authProvider.isManager) {
          return const ManagerHomeScreen();
        } else {
          return const CashierHomeScreen();
        }
      },
    );
  }
}
