

import '../imports/all_imports.dart';
class MyBuffet extends StatefulWidget {
  final SharedPreferences prefs;

  const MyBuffet({super.key, required this.prefs});

  @override
  _MyBuffetState createState() => _MyBuffetState();
  static void setLocale(BuildContext context, Locale locale) {
    _MyBuffetState? state = context.findAncestorStateOfType<_MyBuffetState>();
    state?.setLocale(locale);
  }
}

class _MyBuffetState extends State<MyBuffet> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.prefs.getString('language_code') ?? 'en');
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    widget.prefs.setString('language_code', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider(widget.prefs)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'نظام فواتير البوفيه',
        locale: _locale, // اللغة الحالية
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AE'),
        ],
        localizationsDelegates:  const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        useInheritedMediaQuery: true,
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: widget!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        home: const LoginScreen(),
        routes: {
          '/SettingsPage': (context) => const SettingsPage(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/cashier_home': (context) => const CashierHomeScreen(),
          '/manager_home': (context) => const ManagerHomeScreen(),
          '/products_management': (context) => const ProductsManagementScreen(),
          '/change_password': (context) => const ChangePasswordScreen(),
          '/sales': (context) => const SalesScreen(),
          '/users_management': (context) => const UserManagementScreen(),
          '/reports_management': (context) => const ReportsManagement(),
        },
      ),
    );
  }
}



