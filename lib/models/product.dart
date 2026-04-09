enum ProductCategory {
  healthMix,
  teaBeverages,
  beauty,
  giftCombos,
  preBooking,
}

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.healthMix:
        return 'Health Mixes';
      case ProductCategory.teaBeverages:
        return 'Tea & Beverages';
      case ProductCategory.beauty:
        return 'Natural Beauty';
      case ProductCategory.giftCombos:
        return 'Gift Combos';
      case ProductCategory.preBooking:
        return 'Pre-Booking';
    }
  }

  String get emoji {
    switch (this) {
      case ProductCategory.healthMix:
        return '🌾';
      case ProductCategory.teaBeverages:
        return '🍵';
      case ProductCategory.beauty:
        return '🌸';
      case ProductCategory.giftCombos:
        return '🎁';
      case ProductCategory.preBooking:
        return '📋';
    }
  }

  String get description {
    switch (this) {
      case ProductCategory.healthMix:
        return 'Traditional rice & millet blends';
      case ProductCategory.teaBeverages:
        return 'From 7th Heaven Valparai';
      case ProductCategory.beauty:
        return 'Azhagiya Amudham herbal care';
      case ProductCategory.giftCombos:
        return 'Curated gift sets for loved ones';
      case ProductCategory.preBooking:
        return 'Special order items';
    }
  }
}

// ─── Product Variant ──────────────────────────────────────────────────────────

class ProductVariant {
  final String weight;
  final double price;
  final double discountPercent; // 0–100
  final bool inStock;

  const ProductVariant({
    required this.weight,
    required this.price,
    this.discountPercent = 0,
    this.inStock = true,
  });

  double get effectivePrice =>
      hasDiscount ? price * (1 - discountPercent / 100) : price;

  bool get hasDiscount => discountPercent > 0;

  double get savedAmount => price - effectivePrice;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      weight: json['weight'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      discountPercent: (json['discountPercent'] as num? ?? 0).toDouble(),
      inStock: json['inStock'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'price': price,
        'discountPercent': discountPercent,
        'inStock': inStock,
      };

  ProductVariant copyWith({
    String? weight,
    double? price,
    double? discountPercent,
    bool? inStock,
  }) {
    return ProductVariant(
      weight: weight ?? this.weight,
      price: price ?? this.price,
      discountPercent: discountPercent ?? this.discountPercent,
      inStock: inStock ?? this.inStock,
    );
  }
}

// ─── Product ─────────────────────────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final ProductCategory category;
  final List<ProductVariant> variants;
  final List<String> ingredients;
  final String? badge;
  final bool isPreBooking;
  final bool inStock;
  final String imageEmoji;
  final List<String> highlights;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.variants,
    this.ingredients = const [],
    this.badge,
    this.isPreBooking = false,
    this.inStock = true,
    required this.imageEmoji,
    this.highlights = const [],
  });

  double get minPrice =>
      variants.isNotEmpty
          ? variants.map((v) => v.effectivePrice).reduce((a, b) => a < b ? a : b)
          : 0;

  double get minOriginalPrice =>
      variants.isNotEmpty
          ? variants.map((v) => v.price).reduce((a, b) => a < b ? a : b)
          : 0;

  bool get hasAnyDiscount => variants.any((v) => v.hasDiscount);

  factory Product.fromJson(Map<String, dynamic> json) {
    final categoryStr = json['category'] as String? ?? 'healthMix';
    final category = ProductCategory.values.firstWhere(
      (c) => c.name == categoryStr,
      orElse: () => ProductCategory.healthMix,
    );

    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: category,
      imageEmoji: json['imageEmoji'] as String? ?? '📦',
      badge: json['badge'] as String?,
      isPreBooking: json['isPreBooking'] as bool? ?? false,
      inStock: json['inStock'] as bool? ?? true,
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map((v) => ProductVariant.fromJson(Map<String, dynamic>.from(v as Map)))
          .toList(),
      highlights: List<String>.from(json['highlights'] as List? ?? []),
      ingredients: List<String>.from(json['ingredients'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'description': description,
        'category': category.name,
        'imageEmoji': imageEmoji,
        if (badge != null) 'badge': badge,
        'isPreBooking': isPreBooking,
        'inStock': inStock,
        'variants': variants.map((v) => v.toJson()).toList(),
        'highlights': highlights,
        'ingredients': ingredients,
      };

  Product copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? description,
    ProductCategory? category,
    List<ProductVariant>? variants,
    List<String>? ingredients,
    Object? badge = _sentinel,
    bool? isPreBooking,
    bool? inStock,
    String? imageEmoji,
    List<String>? highlights,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      category: category ?? this.category,
      variants: variants ?? this.variants,
      ingredients: ingredients ?? this.ingredients,
      badge: badge == _sentinel ? this.badge : badge as String?,
      isPreBooking: isPreBooking ?? this.isPreBooking,
      inStock: inStock ?? this.inStock,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      highlights: highlights ?? this.highlights,
    );
  }
}

const Object _sentinel = Object();
