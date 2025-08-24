import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
enum UserRole {
  @HiveField(0)
  manager,
  @HiveField(1)
  cashier,
}

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String password;

  @HiveField(3)
  UserRole role;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  String get roleDisplayName {
    switch (role) {
      case UserRole.manager:
        return 'مدير';
      case UserRole.cashier:
        return 'كاشير';
    }
  }
}

