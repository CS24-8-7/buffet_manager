import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../../data/services/database_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'الكل';

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final categories = _products.map((p) => p.category).toSet().toList();
    categories.insert(0, 'الكل');
    return categories;
  }

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      _products = await DatabaseService.getProducts();
      _applyFilters();
      notifyListeners();
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await DatabaseService.insertProduct(product);
      await loadProducts();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await DatabaseService.updateProduct(product);
      await loadProducts();
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await DatabaseService.deleteProduct(id);
      await loadProducts();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (product.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      final matchesCategory = _selectedCategory == 'الكل' ||
          product.category == _selectedCategory;
      
      return matchesSearch && matchesCategory && product.isAvailable;
    }).toList();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'الكل';
    _applyFilters();
    notifyListeners();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

