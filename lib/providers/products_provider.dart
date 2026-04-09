import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

enum LoadState { idle, loading, loaded, error }

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  LoadState _state = LoadState.idle;
  String _errorMessage = '';

  List<Product> get products => _products;
  LoadState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadState.loading;

  // ─── Fetch ────────────────────────────────────────────────────────────────

  Future<void> loadProducts({bool silent = false}) async {
    if (!silent) {
      _state = LoadState.loading;
      notifyListeners();
    }

    try {
      _products = await ProductService.fetchProducts();
      _state = LoadState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = LoadState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // ─── Admin mutations (call saveToServer after each) ───────────────────────

  void addProduct(Product product) {
    _products = [..._products, product];
    notifyListeners();
  }

  void updateProduct(Product updated) {
    _products = _products.map((p) => p.id == updated.id ? updated : p).toList();
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products = _products.where((p) => p.id != productId).toList();
    notifyListeners();
  }

  void toggleProductStock(String productId) {
    _products = _products.map((p) {
      if (p.id == productId) return p.copyWith(inStock: !p.inStock);
      return p;
    }).toList();
    notifyListeners();
  }

  Future<void> saveToServer() async {
    await ProductService.saveProducts(_products);
  }

  // ─── Queries ──────────────────────────────────────────────────────────────

  List<Product> getByCategory(ProductCategory category) =>
      _products.where((p) => p.category == category).toList();

  List<Product> search(String query) {
    final q = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.subtitle.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.ingredients.any((i) => i.toLowerCase().contains(q)))
        .toList();
  }

  List<Product> getFeatured() =>
      _products.where((p) => p.badge != null && p.category != ProductCategory.preBooking).toList();
}
