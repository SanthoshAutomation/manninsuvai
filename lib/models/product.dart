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

class ProductVariant {
  final String weight;
  final double price;

  const ProductVariant({required this.weight, required this.price});
}

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
    required this.imageEmoji,
    this.highlights = const [],
  });

  double get minPrice =>
      variants.isNotEmpty ? variants.map((v) => v.price).reduce((a, b) => a < b ? a : b) : 0;

  double get maxPrice =>
      variants.isNotEmpty ? variants.map((v) => v.price).reduce((a, b) => a > b ? a : b) : 0;
}
