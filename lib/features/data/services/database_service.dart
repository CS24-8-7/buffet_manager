import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/sale.dart';
class DatabaseService {
  static const String productsBox = 'productsBox';
  static const String usersBox = 'usersBox';
  static const String salesBox = 'salesBox';
  static const String salesItemsBox = 'salesItemsBox';

  static Future<void> initializeDatabase() async {
    await Hive.initFlutter(); // ← يمكن إزالتها من هنا إذا كانت في main()

    _registerAdapterSafe<UserRole>(UserRoleAdapter(), 0);
    _registerAdapterSafe<User>(UserAdapter(), 1);
    _registerAdapterSafe<Product>(ProductAdapter(), 2);
    _registerAdapterSafe<CartItem>(CartItemAdapter(), 3);
    _registerAdapterSafe<Sale>(SaleAdapter(), 4);
    _registerAdapterSafe<SaleItem>(SaleItemAdapter(), 5);

    // ✅ الآن افتح الصناديق
    await Hive.openBox<User>(usersBox);
    await Hive.openBox<Product>(productsBox);
    await Hive.openBox<Sale>(salesBox);
    await Hive.openBox<SaleItem>(salesItemsBox);

    await createDefaultUser();
    await createSampleProducts();
  }
  static void _registerAdapterSafe<T>(TypeAdapter<T> adapter, int typeId) {
    try {
      if (!Hive.isAdapterRegistered(typeId)) {
        Hive.registerAdapter(adapter);
      }
    } on HiveError {
      // تجاهل الخطأ إذا كان مسجلًا مسبقًا
    }
  }



  static Future<void> createDefaultUser() async {
    var box = Hive.box<User>(usersBox);
    if (box.isEmpty) {
      final defaultUser = User(
        id: 1,
        username: 'admin',
        password: '123456',
        role: UserRole.manager,
      );
      await box.put(1, defaultUser);
    }
  }

  static Future<void> createSampleProducts() async {
    var box = Hive.box<Product>(productsBox);
    if (box.isEmpty) {
      final sampleProducts = [
        Product(
          id: 1,
          name: 'برجر لحم',
          price: 25.0,
          category: 'وجبات رئيسية',
          description: 'برجر لحم طازج مع الخضار',
          image: 'assets/images/burger.png',
        ),
        Product(
          id: 2,
          name: 'شاهي',
          price: 35.0,
          category: 'وجبات رئيسية',
          description: 'شاهي احمر',
          image: 'assets/images/pos.png',
        ),
      ];
      for (var product in sampleProducts) {
        await box.put(product.id, product);
      }
    }
  }

  static Future<void> insertProduct(Product product) async {
    var box = Hive.box<Product>(productsBox);
    if (product.id == null) {
      final keys = box.keys.cast<int>();
      product.id = keys.isEmpty ? 1 : keys.reduce((a, b) => a > b ? a : b) + 1;
    }
    await box.put(product.id, product);
  }

  static Future<void> updateProduct(Product product) async {
    await Hive.box<Product>(productsBox).put(product.id, product);
  }

  static Future<void> deleteProduct(int id) async {
    await Hive.box<Product>(productsBox).delete(id);
  }

  static Future<List<Product>> getProducts() async {
    return Hive.box<Product>(productsBox).values.toList();
  }

  static Future<Product?> getProductById(int id) async {
    return Hive.box<Product>(productsBox).get(id);
  }

  static Future<void> insertUser(User user) async {
    var box = Hive.box<User>(usersBox);
    if (user.id == null) {
      final keys = box.keys.cast<int>();
      user.id = keys.isEmpty ? 1 : keys.reduce((a, b) => a > b ? a : b) + 1;
    }
    await box.put(user.id, user);
  }

  static Future<User?> getUserByUsername(String username) async {
    try {
      return Hive.box<User>(usersBox)
          .values
          .firstWhere((user) => user.username == username);
    } catch (_) {
      return null;
    }
  }

  static Future<User?> authenticateUser(String username, String password) async {
    try {
      return Hive.box<User>(usersBox).values.firstWhere(
              (user) => user.username == username && user.password == password);
    } catch (_) {
      return null;
    }
  }

  static Future<int> insertSale(DateTime date, double total,
      String? cashierName, String? notes) async {
    var box = Hive.box<Sale>(salesBox);
    final keys = box.keys.cast<int>();
    final id = keys.isEmpty ? 1 : keys.reduce((a, b) => a > b ? a : b) + 1;

    final sale = Sale(
      id: id,
      date: date,
      total: total,
      cashierName: cashierName,
      notes: notes,
    );
    await box.put(id, sale);
    return id;
  }

  static Future<void> insertSaleItem(int saleId, int productId,
      String productName, int quantity, double price) async {
    var box = Hive.box<SaleItem>(salesItemsBox);
    final keys = box.keys.cast<int>();
    final id = keys.isEmpty ? 1 : keys.reduce((a, b) => a > b ? a : b) + 1;

    final saleItem = SaleItem(
      id: id,
      saleId: saleId,
      productId: productId,
      productName: productName,
      quantity: quantity,
      price: price,
      total: quantity * price,
    );
    await box.put(id, saleItem);
  }

  static Future<List<Sale>> getSales() async {
    return Hive.box<Sale>(salesBox)
        .values
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<List<SaleItem>> getSaleItems(int saleId) async {
    return Hive.box<SaleItem>(salesItemsBox)
        .values
        .where((item) => item.saleId == saleId)
        .toList();
  }

  static Future<Map<String, dynamic>> getSalesStats() async {
    var box = Hive.box<Sale>(salesBox);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthStart = DateTime(now.year, now.month, 1);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    double todayTotal = 0;
    int todayCount = 0;
    double weekTotal = 0;
    double monthTotal = 0;
    int totalSales = box.length;

    for (var sale in box.values) {
      if (sale.date.isAfter(today) || sale.date.isAtSameMomentAs(today)) {
        todayTotal += sale.total;
        todayCount++;
      }
      if (sale.date.isAfter(weekStart) || sale.date.isAtSameMomentAs(weekStart)) {
        weekTotal += sale.total;
      }
      if (sale.date.isAfter(monthStart) || sale.date.isAtSameMomentAs(monthStart)) {
        monthTotal += sale.total;
      }
    }

    return {
      'todayTotal': todayTotal,
      'todayCount': todayCount,
      'weekTotal': weekTotal,
      'monthTotal': monthTotal,
      'totalSales': totalSales,
    };
  }

  static Future<List<Map<String, dynamic>>> getDailySalesData(int days) async {
    var box = Hive.box<Sale>(salesBox);
    final now = DateTime.now();
    final startDate =
    DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));

    Map<String, double> dailySales = {};
    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      dailySales[dateKey] = 0.0;
    }

    for (var sale in box.values) {
      if (sale.date.isAfter(startDate) || sale.date.isAtSameMomentAs(startDate)) {
        final dateKey = '${sale.date.day}/${sale.date.month}';
        dailySales[dateKey] = (dailySales[dateKey] ?? 0) + sale.total;
      }
    }

    return dailySales.entries
        .map((entry) => {'date': entry.key, 'total': entry.value})
        .toList();
  }

  static Future<void> clearAllData() async {
    await Hive.box<Product>(productsBox).clear();
    await Hive.box<User>(usersBox).clear();
    await Hive.box<Sale>(salesBox).clear();
    await Hive.box<SaleItem>(salesItemsBox).clear();
  }
}

