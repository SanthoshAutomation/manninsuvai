class OrderItem {
  final String productName;
  final String variantWeight;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productName,
    required this.variantWeight,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json['productName'] as String? ?? '',
        variantWeight: json['variantWeight'] as String? ?? '',
        quantity: (json['quantity'] as num? ?? 1).toInt(),
        price: (json['price'] as num? ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'variantWeight': variantWeight,
        'quantity': quantity,
        'price': price,
      };
}

class AppOrder {
  final String id;
  final DateTime placedAt;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryCharge;
  final String platform; // 'android' | 'web'

  const AppOrder({
    required this.id,
    required this.placedAt,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.platform,
  });

  double get total => subtotal + deliveryCharge;
  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  factory AppOrder.fromJson(Map<String, dynamic> json) => AppOrder(
        id: json['id'] as String? ?? '',
        placedAt: DateTime.tryParse(json['placedAt'] as String? ?? '') ?? DateTime.now(),
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        subtotal: (json['subtotal'] as num? ?? 0).toDouble(),
        deliveryCharge: (json['deliveryCharge'] as num? ?? 0).toDouble(),
        platform: json['platform'] as String? ?? 'web',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'placedAt': placedAt.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryCharge': deliveryCharge,
        'platform': platform,
      };
}
