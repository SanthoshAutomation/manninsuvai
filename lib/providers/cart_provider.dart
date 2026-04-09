import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/order_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Returns the configured delivery charge.
  /// -1 = contact for charges (default)
  ///  0 = free
  /// >0 = fixed amount
  Future<double> getDeliveryCharge() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getDouble(AppConfigKeys.deliveryCharge) ?? -1);
  }

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

  /// Saves this order to the server (called right before opening WhatsApp).
  Future<void> saveOrderToServer(double deliveryCharge) async {
    if (_items.isEmpty) return;
    final order = AppOrder(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      placedAt: DateTime.now(),
      items: _items
          .map((i) => OrderItem(
                productName: i.product.name,
                variantWeight: i.variant.weight,
                quantity: i.quantity,
                price: i.variant.effectivePrice,
              ))
          .toList(),
      subtotal: subtotal,
      deliveryCharge: deliveryCharge < 0 ? 0 : deliveryCharge,
      platform: kIsWeb ? 'web' : 'android',
    );
    await OrderService.saveOrder(order);
  }

  String buildWhatsAppMessage({double deliveryCharge = -1}) {
    final buffer = StringBuffer();
    buffer.writeln('🛒 *New Order from Mannin Suvai App*');
    buffer.writeln('');
    buffer.writeln('*Order Details:*');
    buffer.writeln('─────────────────');

    for (final item in _items) {
      final isPreBook = item.product.isPreBooking;
      buffer.writeln(
        '• ${item.product.name}${isPreBook ? ' [PRE-BOOK]' : ''} (${item.variant.weight}) × ${item.quantity}',
      );
      if (item.variant.price > 0) {
        buffer.writeln(
          '  ₹${item.variant.effectivePrice.toStringAsFixed(0)} × ${item.quantity} = ₹${item.totalPrice.toStringAsFixed(0)}',
        );
      } else {
        buffer.writeln('  Price: On request');
      }
    }

    buffer.writeln('─────────────────');
    if (subtotal > 0) {
      buffer.writeln('Subtotal: ₹${subtotal.toStringAsFixed(0)}');
      if (deliveryCharge > 0) {
        buffer.writeln('Delivery: ₹${deliveryCharge.toStringAsFixed(0)}');
        buffer.writeln('*Total: ₹${(subtotal + deliveryCharge).toStringAsFixed(0)}*');
      } else if (deliveryCharge == 0) {
        buffer.writeln('Delivery: Free');
        buffer.writeln('*Total: ₹${subtotal.toStringAsFixed(0)}*');
      } else {
        buffer.writeln('*Total: ₹${subtotal.toStringAsFixed(0)}* (+ delivery charges)');
      }
    }
    buffer.writeln('');
    buffer.writeln('Please confirm my order. Thank you! 🙏');

    return Uri.encodeComponent(buffer.toString());
  }
}
