import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_theme.dart';
import '../../../data/models/user.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserRole _selectedRole = UserRole.cashier;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final newUser = await authProvider.register(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
          _selectedRole,
        );

        if (mounted) {
          if (newUser != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تم إنشاء الحساب بنجاح!'),
              ),
            );
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('اسم المستخدم موجود بالفعل'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ أثناء إنشاء الحساب: $e'),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.person_add,
                      size: ResponsiveHelper.getIconSize(context) * 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'إنشاء حساب جديد',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // حقل اسم المستخدم
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المستخدم',
                        prefixIcon: Icon(Icons.person),
                        hintText: 'أدخل اسم المستخدم',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال اسم المستخدم';
                        }
                        if (value.trim().length < 3) {
                          return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // حقل كلمة المرور
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: 'أدخل كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.trim().length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // حقل تأكيد كلمة المرور
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        hintText: 'أعد إدخال كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء تأكيد كلمة المرور';
                        }
                        if (value != _passwordController.text) {
                          return 'كلمة المرور غير متطابقة';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'نوع المستخدم',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider), // ✅ تم التصحيح
                        borderRadius: BorderRadius.circular(AppConstants.radiusS),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<UserRole>(
                            title: const Text('كاشير'),
                            subtitle: const Text('يمكنه إجراء المبيعات وطباعة الفواتير'),
                            value: UserRole.cashier,
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                          RadioListTile<UserRole>(
                            title: const Text('مدير'),
                            subtitle: const Text('يمكنه إدارة المنتجات والمستخدمين والتقارير'),
                            value: UserRole.manager,
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                            : const Text('إنشاء الحساب'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // يرجعك لصفحة تسجيل الدخول
                          },
                          child: const Text(
                            'سجل دخولك',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                        const Text(
                          'لديك حساب بالفعل؟',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}