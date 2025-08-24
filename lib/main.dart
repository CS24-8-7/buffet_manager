import 'package:buffet_invoice_system/core/imports/all_imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await DatabaseService.initializeDatabase();

  if (!kReleaseMode) {
    await SampleData.resetAllData();
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyBuffet(prefs: prefs),
    ),
  );
}
