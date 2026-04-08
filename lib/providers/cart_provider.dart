import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool isInCart(String productId, String variantWeight) {
    return _items.any(
      (item) => item.product.id == productId && item.variant.weight == variantWeight,
    );
  }

  void addItem(Product product, ProductVariant variant) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.variant.weight == variant.weight,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, variant: variant));
    }
    notifyListeners();
  }

  void removeItem(String productId, String variantWeight) {
    _items.removeWhere(
      (item) => item.product.id == productId && item.variant.weight == variantWeight,
    );
    notifyListeners();
  }

  void updateQuantity(String productId, String variantWeight, int quantity) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.variant.weight == variantWeight,
    );

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  String buildWhatsAppMessage() {
    final buffer = StringBuffer();
    buffer.writeln('🛒 *New Order from Mannin Suvai App*');
    buffer.writeln('');
    buffer.writeln('*Order Details:*');
    buffer.writeln('─────────────────');

    for (final item in _items) {
      buffer.writeln(
        '• ${item.product.name} (${item.variant.weight}) × ${item.quantity}',
      );
      if (item.variant.price > 0) {
        buffer.writeln(
          '  ₹${item.variant.price} × ${item.quantity} = ₹${item.totalPrice.toStringAsFixed(0)}',
        );
      } else {
        buffer.writeln('  Price: On request');
      }
    }

    buffer.writeln('─────────────────');
    if (totalAmount > 0) {
      buffer.writeln('*Total: ₹${totalAmount.toStringAsFixed(0)}*');
    }
    buffer.writeln('');
    buffer.writeln('Please confirm my order. Thank you! 🙏');

    return Uri.encodeComponent(buffer.toString());
  }
}
