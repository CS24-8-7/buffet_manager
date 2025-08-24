

import '../../features/data/models/product.dart';
import '../../features/data/models/user.dart';
import '../../features/data/services/database_service.dart';

class SampleData {
  static Future<void> initializeSampleData() async {
    try {
      await _createDefaultUsers();
      await _createSampleProducts();

      print('تم إنشاء البيانات التجريبية بنجاح');
    } catch (e) {
      print('خطأ في إنشاء البيانات التجريبية: $e');
    }
  }

  static Future<void> _createDefaultUsers() async {
    final existingUser = await DatabaseService.getUserByUsername('admin');
    if (existingUser == null) {
      await DatabaseService.insertUser(
        User(
          username: 'admin',
          password: '123456',
          role: UserRole.manager,
        ),
      );
      print('تم إنشاء المستخدم الافتراضي: admin');
    }

    final existingCashier = await DatabaseService.getUserByUsername('cashier1');
    if (existingCashier == null) {
      await DatabaseService.insertUser(
        User(
          username: 'cashier1',
          password: '123456',
          role: UserRole.cashier,
        ),
      );
      print('تم إنشاء الكاشير التجريبي: cashier1');
    }
  }

  static Future<void> _createSampleProducts() async {
    final sampleProducts = [
      Product(
          name: ' شاهي',
          price: 15.0,
          category: 'مشروبات',
          image: 'assets/images/pos.png'),
      Product(
          name: 'شاي أحمر',
          price: 8.0,
          category: 'مشروبات',
          image: 'assets/images/pos.png'),
    ];

    for (final product in sampleProducts) {
      try {
        await DatabaseService.insertProduct(product);
      } catch (e) {
        print('المنتج ${product.name} موجود بالفعل أو حدث خطأ: $e');
      }
    }

    print('تم إنشاء ${sampleProducts.length} منتج تجريبي');
  }

  static Future<void> createSampleSales() async {
    try {
      // إنشاء بعض المبيعات التجريبية
      final now = DateTime.now();

      // مبيعات اليوم
      for (int i = 0; i < 5; i++) {
        final saleDate = now.subtract(Duration(hours: i * 2));
        final saleId = await DatabaseService.insertSale(
          saleDate,
          (50 + i * 15).toDouble(),
          'cashier1',
          i == 0 ? 'طلب خاص للعميل' : null,
        );

        // إضافة عناصر للمبيعة
        await DatabaseService.insertSaleItem(
          saleId,
          1, // معرف المنتج
          'قهوة عربية',
          2,
          15.0,
        );

        await DatabaseService.insertSaleItem(
          saleId,
          2, // معرف المنتج
          'برجر لحم',
          1,
          35.0,
        );
      }

      // مبيعات الأسبوع الماضي
      for (int i = 1; i <= 7; i++) {
        final saleDate = now.subtract(Duration(days: i));
        final saleId = await DatabaseService.insertSale(
          saleDate,
          (80 + i * 20).toDouble(),
          'admin',
          null,
        );

        await DatabaseService.insertSaleItem(
          saleId,
          3,
          'دجاج مشوي',
          1,
          45.0,
        );
      }

      print('تم إنشاء مبيعات تجريبية');
    } catch (e) {
      print('خطأ في إنشاء المبيعات التجريبية: $e');
    }
  }

  static Future<void> resetAllData() async {
    try {
      // حذف جميع البيانات
      await DatabaseService.clearAllData();

      // إعادة إنشاء البيانات التجريبية
      await initializeSampleData();
      await createSampleSales();

      print('تم إعادة تعيين جميع البيانات');
    } catch (e) {
      print('خطأ في إعادة تعيين البيانات: $e');
    }
  }
}
