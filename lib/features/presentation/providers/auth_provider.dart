import 'package:flutter/material.dart';
import '../../data/models/user.dart';
import '../../data/services/database_service.dart';


class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isManager => _currentUser?.role == UserRole.manager;
  bool get isCashier => _currentUser?.role == UserRole.cashier;

  Future<User?> login(String username, String password) async {
    try {
      final user = await DatabaseService.authenticateUser(username, password);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
      return user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<User?> register(String username, String password, UserRole role) async {
    try {
      final existingUser = await DatabaseService.getUserByUsername(username);
      if (existingUser != null) {
        return null; // المستخدم موجود بالفعل
      }
      
      final newUser = User(
        username: username,
        password: password,
        role: role,
      );
      
      await DatabaseService.insertUser(newUser);
      return newUser;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) return false;
    
    try {
      if (_currentUser!.password != oldPassword) {
        return false; // كلمة المرور القديمة غير صحيحة
      }
      
      _currentUser!.password = newPassword;
      await DatabaseService.insertUser(_currentUser!);
      notifyListeners();
      return true;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }
}

