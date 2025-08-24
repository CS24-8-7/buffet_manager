import 'package:flutter/material.dart';

import '../../data/models/sale.dart';
import '../../data/services/database_service.dart';

class SalesProvider with ChangeNotifier {
  List<Sale> _sales = [];
  Map<String, dynamic> _salesStats = {};
  List<Map<String, dynamic>> _dailySalesData = [];

  List<Sale> get sales => _sales;
  Map<String, dynamic> get salesStats => _salesStats;
  List<Map<String, dynamic>> get dailySalesData => _dailySalesData;

  double get todayTotal => (_salesStats['todayTotal'] ?? 0.0).toDouble();
  int get todayCount => (_salesStats['todayCount'] ?? 0);
  double get weekTotal => (_salesStats['weekTotal'] ?? 0.0).toDouble();
  double get monthTotal => (_salesStats['monthTotal'] ?? 0.0).toDouble();
  int get totalSales => (_salesStats['totalSales'] ?? 0);

  String get formattedTodayTotal => '${todayTotal.toStringAsFixed(2)} ريال';
  String get formattedWeekTotal => '${weekTotal.toStringAsFixed(2)} ريال';
  String get formattedMonthTotal => '${monthTotal.toStringAsFixed(2)} ريال';

  SalesProvider() {
    loadSalesData();
  }

  Future<void> loadSalesData() async {
    try {
      _sales = await DatabaseService.getSales();
      _salesStats = await DatabaseService.getSalesStats();
      _dailySalesData = await DatabaseService.getDailySalesData(7); // آخر 7 أيام
      notifyListeners();
    } catch (e) {
      print('Error loading sales data: $e');
    }
  }

  Future<List<SaleItem>> getSaleItems(int saleId) async {
    try {
      return await DatabaseService.getSaleItems(saleId);
    } catch (e) {
      print('Error loading sale items: $e');
      return [];
    }
  }

  Future<void> refreshData() async {
    await loadSalesData();
  }

  List<Sale> getSalesByDateRange(DateTime startDate, DateTime endDate) {
    return _sales.where((sale) {
      return sale.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
             sale.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  List<Sale> getTodaySales() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return _sales.where((sale) {
      return sale.date.isAfter(startOfDay) && sale.date.isBefore(endOfDay);
    }).toList();
  }

  double getAverageOrderValue() {
    if (_sales.isEmpty) return 0.0;
    final totalRevenue = _sales.fold(0.0, (sum, sale) => sum + sale.total);
    return totalRevenue / _sales.length;
  }

  Map<String, int> getTopSellingProducts() {
    // هذه الدالة تحتاج إلى تحسين لجلب بيانات المنتجات الأكثر مبيعاً
    // يمكن تطويرها لاحقاً لتحليل بيانات SaleItem
    return {};
  }
}

