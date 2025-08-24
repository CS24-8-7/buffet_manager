import '../../../../core/imports/all_imports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = await authProvider.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        if (mounted) {
          if (user != null) {
            final username = _usernameController.text.trim();
            final password = _passwordController.text.trim();
            if (username == 'admin' && password == '123456') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('يرجى تغيير كلمة المرور للمرة الأولى'),
                  duration: Duration(milliseconds: 500), // 2.5 ثانية
                ),
              );
              Navigator.pushReplacementNamed(context, '/change_password');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('مرحباً ${user.username}!'),
                  duration: Duration(milliseconds: 500), // 2.5 ثانية
                ),
              );
              if (user.role == 'manager') {
                Navigator.pushReplacementNamed(context, '/manager_home');
              } else {
                Navigator.pushReplacementNamed(context, '/cashier_home');
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('اسم المستخدم أو كلمة المرور غير صحيحة'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ أثناء تسجيل الدخول: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // أيقونة تسجيل الدخول
                    Icon(
                      Icons.restaurant_menu,
                      size: ResponsiveHelper.getIconSize(context) * 2,
                      color: theme.colorScheme.primary,
                    ),

                    const SizedBox(height: 24),

                    // عنوان تسجيل الدخول
                    Text(
                      'تسجيل الدخول',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // ملاحظات بيانات المستخدم الافتراضي
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'بيانات المستخدم الافتراضي:',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('اسم المستخدم: admin',
                              style: theme.textTheme.bodySmall),
                          Text('كلمة المرور: 123456',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
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
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: 'أدخل كلمة المرور',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                    ),

                    const SizedBox(height: 32),

                    // زر تسجيل الدخول
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
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
                            : const Text('تسجيل الدخول'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // النص وزر إنشاء الحساب (بنفس ستايل الريجستر)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          child: const Text(
                            'إنشاء حساب جديد',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                        const Text(
                          'لا تملك حساب؟',
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
