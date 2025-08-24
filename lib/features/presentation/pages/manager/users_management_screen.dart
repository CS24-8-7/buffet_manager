import 'package:flutter/material.dart';
import '../../../data/models/user.dart';
import '../../../data/services/database_service.dart';
import '../../widgets/common/app_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  Future<void> _addUser(BuildContext context) async {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    UserRole role = UserRole.cashier;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة مستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'اسم المستخدم'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            DropdownButton<UserRole>(
              value: role,
              items: UserRole.values.map((r) {
                return DropdownMenuItem(
                  value: r,
                  child: Text(r == UserRole.manager ? 'مدير' : 'كاشير'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) role = value;
              },
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              // ✅ تم التصحيح: استخدام الاسم الصحيح من DatabaseService
              final box = Hive.box<User>(DatabaseService.usersBox);
              await box.add(User(
                username: usernameController.text,
                password: passwordController.text,
                role: role,
              ));
              Navigator.pop(ctx);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _editUser(BuildContext context, User user) async {
    final usernameController = TextEditingController(text: user.username);
    final passwordController = TextEditingController(text: user.password);
    UserRole role = user.role;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل مستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'اسم المستخدم'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            DropdownButton<UserRole>(
              value: role,
              items: UserRole.values.map((r) {
                return DropdownMenuItem(
                  value: r,
                  child: Text(r == UserRole.manager ? 'مدير' : 'كاشير'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) role = value;
              },
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              user.username = usernameController.text;
              user.password = passwordController.text;
              user.role = role;

              // ✅ تم التصحيح: استخدام الصندوق الصحيح
              final box = Hive.box<User>(DatabaseService.usersBox);
              await box.put(user.id, user);

              Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
      ),
      drawer: const AppDrawer(currentRoute: '/users_management'),
      body: ValueListenableBuilder(
        // ✅ تم التصحيح: استخدام الاسم الصحيح من DatabaseService
        valueListenable: Hive.box<User>(DatabaseService.usersBox).listenable(),
        builder: (context, Box<User> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('لا يوجد مستخدمين'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final user = box.getAt(index);
              return ListTile(
                title: Text(user!.username),
                subtitle: Text(user.roleDisplayName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editUser(context, user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // ✅ تم التصحيح: استخدام الصندوق الصحيح
                        Hive.box<User>(DatabaseService.usersBox).delete(user.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addUser(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}