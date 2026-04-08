import '../models/product.dart';

class ProductsData {
  static const List<Product> products = [
    // ─── HEALTH MIXES ────────────────────────────────────────────────────────

    Product(
      id: 'hm_nutri_rice',
      name: 'Nutri Rice Health Mix',
      subtitle: '30+ selected raw materials',
      description:
          'A premium health mix crafted from 10 traditional rice varieties of Tamil Nadu, '
          'blended with power-packed pulses, premium dry fruits, and natural spices. '
          'Rich in nutrients, fibre, and antioxidants — perfect for the whole family.',
      category: ProductCategory.healthMix,
      imageEmoji: '🍚',
      badge: 'Bestseller',
      variants: [
        ProductVariant(weight: '350 g', price: 480),
        ProductVariant(weight: '500 g', price: 680),
        ProductVariant(weight: '700 g', price: 955),
        ProductVariant(weight: '1000 g', price: 1280),
      ],
      highlights: [
        '10 Traditional Rice Varieties',
        '30+ Raw Materials',
        'Rich in Antioxidants',
        'Suitable for All Ages',
        'No Preservatives',
      ],
      ingredients: [
        // Traditional Rice Varieties
        'Karungkuruvai Rice (Traditional Black Rice)',
        'Kattuyanam Rice (Traditional Red Rice)',
        'Mappillai Samba Rice',
        'Seeraga Samba Rice',
        'Karudan Samba Rice',
        'Rathasali Rice (Red Rice)',
        'Poongar Rice',
        'Thuyamalli Rice',
        'Black Kavuni Rice',
        'Thanga Puspham Rice',
        // Pulses, Nuts & Seeds
        'Black Chickpeas (Kala Chana)',
        'White Chickpeas (Kabuli Chana)',
        'Kidney Beans',
        'Green Gram (Moong Dal)',
        'Horse Gram',
        'Bengal Gram Dal (Chana Dal)',
        'Peanuts (Groundnuts)',
        'Black Urad Dal',
        'White Urad Dal',
        'Wheat',
        // Dry Fruits
        'Cashew Nuts',
        'Almonds',
        'Pistachios',
        'Walnuts',
        'Fox Nuts (Lotus Seeds)',
        // Spices
        'Fenugreek Seeds',
        'Dry Ginger',
        'Asafoetida (Hing)',
        'Sunflower Seeds',
        'Salt & Cardamom',
      ],
    ),

    Product(
      id: 'hm_multi_millets',
      name: 'Multi Millets Health Mix',
      subtitle: '30+ selected raw materials',
      description:
          'A powerhouse blend of 9 ancient millet varieties combined with diverse pulses, '
          'nuts, and natural spices. Millets are superfoods packed with protein, iron, '
          'and dietary fibre — ideal for weight management and overall wellness.',
      category: ProductCategory.healthMix,
      imageEmoji: '🌾',
      badge: 'Popular',
      variants: [
        ProductVariant(weight: '350 g', price: 455),
        ProductVariant(weight: '500 g', price: 655),
        ProductVariant(weight: '700 g', price: 930),
        ProductVariant(weight: '1000 g', price: 1250),
      ],
      highlights: [
        '9 Millet Varieties',
        '30+ Raw Materials',
        'High in Fibre & Protein',
        'Weight Management',
        'Diabetic Friendly',
      ],
      ingredients: [
        // Millets & Grains
        'Ragi (Finger Millet)',
        'Kuthiraivalli (Barnyard Millet)',
        'Samai (Little Millet)',
        'Varagu (Kodo Millet)',
        'Thinai (Foxtail Millet)',
        'Kambu (Pearl Millet)',
        'White Cholam (White Sorghum)',
        'Red Cholam (Red Sorghum)',
        'Wheat',
        // Pulses & Legumes
        'Green Gram (Whole Moong)',
        'White Cowpea (Lobia)',
        'Black Cowpea',
        'Black Chickpeas (Kala Chana)',
        'White Chickpeas (Kabuli Chana)',
        'Field Beans (Hyacinth Beans)',
        'Lima Beans (Mochai)',
        'Peanuts (Groundnuts)',
        'White Urad Dal',
        'Black Urad Dal',
        'Roasted Bengal Gram',
        // Dry Fruits & Nuts
        'Cashew Nuts',
        'Almonds',
        'Pistachios',
        'Fox Nuts (Lotus Seeds)',
        'Sunflower Seeds',
        // Spices
        'Fenugreek Seeds',
        'Dry Ginger',
        'Black Pepper',
        'Salt & Cardamom',
        'Asafoetida (Hing)',
      ],
    ),

    Product(
      id: 'hm_karuppu_urad',
      name: 'Karuppu Urad Dal Kanji Mix',
      subtitle: '17 selected raw materials',
      description:
          'Traditional Kanji/Kali mix made with Black & White Urad Dal, premium nuts, '
          'and warming spices. This age-old recipe supports digestion, boosts immunity, '
          'and provides sustained energy. Ready to mix with warm water or milk.',
      category: ProductCategory.healthMix,
      imageEmoji: '🫘',
      variants: [
        ProductVariant(weight: '350 g', price: 485),
        ProductVariant(weight: '500 g', price: 630),
        ProductVariant(weight: '700 g', price: 880),
        ProductVariant(weight: '1000 g', price: 1280),
      ],
      highlights: [
        'Black & White Urad Dal',
        'Premium Nuts Blend',
        'Aids Digestion',
        'Boosts Immunity',
        'Traditional Recipe',
      ],
      ingredients: [
        'Black Urad Dal (Black Gram)',
        'White Urad Dal',
        'Wheat',
        'Cashew Nuts',
        'Almonds',
        'Pistachios',
        'Walnuts',
        'Fox Nuts (Lotus Seeds)',
        'Peanuts (Groundnuts)',
        'Roasted Bengal Gram',
        'Sunflower Seeds',
        'Cardamom',
        'Dry Ginger',
        'Black Pepper',
        'Fenugreek Seeds',
        'Asafoetida (Hing)',
        'Salt',
      ],
    ),

    // ─── PRE-BOOKING ITEMS ───────────────────────────────────────────────────

    Product(
      id: 'pb_multigrain_atta',
      name: 'Multi Grain Atta',
      subtitle: 'Chapathi & Poori Flour',
      description:
          'Nutritious multi-grain flour perfect for making healthy chapathis and pooris. '
          'A wholesome blend of grains that makes your everyday rotis more nutritious '
          'without compromising on taste. Available in 500g and 1kg.',
      category: ProductCategory.preBooking,
      imageEmoji: '🫓',
      isPreBooking: true,
      variants: [
        ProductVariant(weight: '500 g', price: 0),
        ProductVariant(weight: '1000 g', price: 0),
      ],
      highlights: [
        'Multi-Grain Blend',
        'Soft Chapathis',
        'Nutritious Pooris',
        'No Maida',
        'Pre-booking only',
      ],
    ),

    Product(
      id: 'pb_ellu_idly_podi',
      name: 'Ellu Idly Podi',
      subtitle: 'Sesame Idly Powder',
      description:
          'Traditional sesame-based idly podi with a rich nutty flavour. '
          'Mix with gingelly oil or ghee and enjoy with idly, dosa, or rice. '
          'Made fresh on order with no preservatives.',
      category: ProductCategory.preBooking,
      imageEmoji: '🌑',
      isPreBooking: true,
      variants: [
        ProductVariant(weight: '200 g', price: 250),
        ProductVariant(weight: '300 g', price: 380),
      ],
      highlights: [
        'Rich Sesame Flavour',
        'No Preservatives',
        'Traditional Recipe',
        'Great with Idly & Dosa',
      ],
    ),

    Product(
      id: 'pb_moringa_podi',
      name: 'Moringa Idly Podi',
      subtitle: 'Moringa Leaves & Seeds Blend',
      description:
          'A superfood podi made with moringa leaves blended with seeds. '
          'Moringa is called the "miracle tree" — packed with vitamins, minerals, '
          'and antioxidants. Ready to eat with steam rice with oil or ghee.',
      category: ProductCategory.preBooking,
      imageEmoji: '🌿',
      isPreBooking: true,
      variants: [
        ProductVariant(weight: '250 g', price: 450),
      ],
      highlights: [
        'Moringa Superfood',
        'Rich in Vitamins',
        'Ready to Eat',
        'With Steam Rice',
      ],
    ),

    Product(
      id: 'pb_masala_chai',
      name: 'Indian Masala Chai Powder',
      subtitle: 'Traditional Chai Blend',
      description:
          'An aromatic blend of traditional Indian spices to make the perfect masala chai. '
          'Just add a spoonful to your regular tea for a fragrant, immunity-boosting cup. '
          'A comforting blend of cardamom, ginger, cloves, and more.',
      category: ProductCategory.preBooking,
      imageEmoji: '☕',
      isPreBooking: true,
      variants: [
        ProductVariant(weight: '100 g', price: 430),
      ],
      highlights: [
        'Aromatic Spice Blend',
        'Immunity Boosting',
        'Traditional Recipe',
        'Easy to Use',
      ],
    ),

    // ─── TEA & BEVERAGES ─────────────────────────────────────────────────────

    Product(
      id: 'tb_tea_premium',
      name: 'Premium Tea',
      subtitle: 'From 7th Heaven, Valparai',
      description:
          'Finest quality tea sourced directly from the lush tea gardens of Valparai — '
          'nature\'s best place to taste premium tea. Available in multiple grades to '
          'suit every palate and budget.',
      category: ProductCategory.teaBeverages,
      imageEmoji: '🍃',
      badge: 'Fresh from Valparai',
      variants: [
        ProductVariant(weight: 'Premium /kg', price: 450),
        ProductVariant(weight: 'Premium Grade 2 /kg', price: 400),
        ProductVariant(weight: 'Premium Grade 3 /kg', price: 370),
        ProductVariant(weight: 'Medium Grade 1 /kg', price: 300),
        ProductVariant(weight: 'Medium Grade 2 /kg', price: 280),
        ProductVariant(weight: 'Low Grade /kg', price: 250),
      ],
      highlights: [
        'Directly from Valparai',
        'Multiple Grades',
        'Fresh Harvest',
        'Strong Flavour',
      ],
    ),

    Product(
      id: 'tb_flavoured_tea',
      name: 'Flavoured Tea',
      subtitle: 'Ellachi, Ginger, Masala & Chocolate',
      description:
          'Delightful flavoured teas that bring a new dimension to your daily tea ritual. '
          'Choose from Ellachi (Cardamom), Ginger, Masala blend, or indulgent Chocolate tea. '
          'Each 200g pack brews numerous aromatic cups.',
      category: ProductCategory.teaBeverages,
      imageEmoji: '🫖',
      variants: [
        ProductVariant(weight: 'Ellachi Tea 200g', price: 180),
        ProductVariant(weight: 'Ginger Tea 200g', price: 180),
        ProductVariant(weight: 'Masala Tea Blend 200g', price: 180),
        ProductVariant(weight: 'Chocolate Tea 200g', price: 180),
        ProductVariant(weight: 'Aavaram Poo (per pocket)', price: 45),
        ProductVariant(weight: 'Masala Blend (per pocket)', price: 35),
      ],
      highlights: [
        '4 Flavour Variants',
        'No Artificial Flavours',
        'Aromatic Blend',
        'Immunity Boosting',
      ],
    ),

    Product(
      id: 'tb_green_tea',
      name: 'Green Tea',
      subtitle: 'Valparai Green Tea Leaf & Dust',
      description:
          'Pure green tea sourced from Valparai\'s finest estates. '
          'Rich in antioxidants and catechins, green tea supports metabolism, '
          'weight management, and provides gentle energy without jitters.',
      category: ProductCategory.teaBeverages,
      imageEmoji: '🌱',
      variants: [
        ProductVariant(weight: 'Green Tea Leaf 1kg', price: 650),
        ProductVariant(weight: 'Green Tea Leaf 500g', price: 350),
        ProductVariant(weight: 'Green Tea Dust 1kg', price: 430),
        ProductVariant(weight: 'Green Tea Dust 500g', price: 220),
      ],
      highlights: [
        'Rich in Antioxidants',
        'Weight Management',
        'Boosts Metabolism',
        'Pure & Natural',
      ],
    ),

    Product(
      id: 'tb_coffee',
      name: 'Pure Filter Coffee',
      subtitle: '100% Pure South Indian Coffee',
      description:
          'Authentic South Indian filter coffee powder for the perfect traditional brew. '
          'Available in 100% pure grade for coffee connoisseurs and a value-grade option. '
          'Rich aroma, bold flavour — just like home.',
      category: ProductCategory.teaBeverages,
      imageEmoji: '☕',
      variants: [
        ProductVariant(weight: '100% Pure 200g', price: 250),
        ProductVariant(weight: '2nd Quality 200g', price: 200),
      ],
      highlights: [
        '100% Pure Grade Available',
        'Rich Aroma',
        'Bold Flavour',
        'South Indian Style',
      ],
    ),

    Product(
      id: 'tb_honey',
      name: 'Natural Honey',
      subtitle: 'Pure & Unprocessed',
      description:
          'Pure, unprocessed natural honey with all its beneficial enzymes and nutrients intact. '
          'No artificial sweeteners or additives. Use as a natural sweetener, '
          'for skincare, or as a health tonic.',
      category: ProductCategory.teaBeverages,
      imageEmoji: '🍯',
      badge: 'Pure',
      variants: [
        ProductVariant(weight: '250 g', price: 260),
        ProductVariant(weight: '500 g', price: 520),
        ProductVariant(weight: '1000 g', price: 950),
      ],
      highlights: [
        'Unprocessed & Pure',
        'No Added Sugar',
        'Natural Enzymes',
        'Multi-purpose Use',
      ],
    ),

    Product(
      id: 'tb_eucalyptus_oil',
      name: 'Eucalyptus Oil',
      subtitle: 'Natural Therapeutic Oil',
      description:
          'Pure eucalyptus oil with natural therapeutic properties. '
          'Used for steam inhalation, massage, and as a natural remedy for cold and congestion. '
          'Contact us for pricing and availability.',
      category: ProductCategory.teaBeverages,
      imageEmoji: '🌿',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        'Natural & Pure',
        'Steam Inhalation',
        'Cold Relief',
        'Therapeutic Grade',
      ],
    ),

    Product(
      id: 'tb_pepper',
      name: 'Black Pepper',
      subtitle: 'Whole & Ground',
      description:
          'Premium quality black pepper — the "King of Spices." '
          'Freshly sourced for maximum flavour and aroma. '
          'Contact us for pricing and availability.',
      category: ProductCategory.teaBeverages,
      imageEmoji: '🌶️',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        'Premium Quality',
        'Fresh Sourced',
        'Rich Aroma',
        'Maximum Potency',
      ],
    ),

    // ─── NATURAL BEAUTY (AZHAGIYA AMUDHAM) ──────────────────────────────────

    Product(
      id: 'beauty_manjal_podi',
      name: 'Manjal Kuliyal Podi',
      subtitle: '25 Traditional Herbal Ingredients',
      description:
          'A traditional turmeric bath powder made from 25 carefully chosen herbs and natural '
          'ingredients. Used for centuries in Tamil culture, this bath powder brightens skin, '
          'reduces blemishes, and leaves skin glowing and fragrant.',
      category: ProductCategory.beauty,
      imageEmoji: '💛',
      badge: 'Traditional',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        '25 Herbal Ingredients',
        'Skin Brightening',
        'Reduces Blemishes',
        'Natural Glow',
        'Safe for All Ages',
      ],
    ),

    Product(
      id: 'beauty_nalangu_maavu',
      name: 'Nalangu Maavu',
      subtitle: 'Traditional Bath Powder for All Genders',
      description:
          'The traditional Nalangu Maavu used in Tamil wedding rituals and daily skincare. '
          'A luxurious blend of natural flours and herbs that cleanses, softens, '
          'and nourishes skin. Suitable for men, women, and children.',
      category: ProductCategory.beauty,
      imageEmoji: '🌼',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        'For All Genders',
        'Deep Cleansing',
        'Skin Softening',
        'Chemical-free',
        'Traditional Recipe',
      ],
    ),

    Product(
      id: 'beauty_maruthani',
      name: 'Maruthani Powder',
      subtitle: 'Natural Henna (Mehendi)',
      description:
          'Pure, natural henna (maruthani) powder made from fresh henna leaves. '
          'Gives rich, deep colour for hair colouring and hand decoration. '
          'Cooling properties that soothe the scalp and condition hair naturally.',
      category: ProductCategory.beauty,
      imageEmoji: '🌿',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        'Pure Henna Leaves',
        'Rich Colour',
        'Cooling Properties',
        'Conditions Hair',
        'No Chemicals',
      ],
    ),

    Product(
      id: 'beauty_rose_powder',
      name: 'Rose Powder & Oil Massage',
      subtitle: 'Rose Petal Skin Care',
      description:
          'Luxurious rose petal powder and massage oil for radiant, soft skin. '
          'Rose has been treasured for centuries for its skin-loving properties — '
          'hydrating, anti-aging, and wonderfully fragrant.',
      category: ProductCategory.beauty,
      imageEmoji: '🌹',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        'Real Rose Petals',
        'Deep Hydration',
        'Anti-Aging',
        'Natural Fragrance',
        'Glowing Skin',
      ],
    ),

    Product(
      id: 'beauty_aloe_vera',
      name: 'Aloe Vera Gel',
      subtitle: '3 Natural Ingredients',
      description:
          'Pure aloe vera gel made with just 3 natural ingredients — no parabens, '
          'no sulphates, no synthetic additives. Perfect as a daily moisturiser, '
          'after-sun soother, hair gel, and spot treatment.',
      category: ProductCategory.beauty,
      imageEmoji: '🌵',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        'Only 3 Ingredients',
        'No Preservatives',
        'Multi-purpose',
        'Hair & Skin',
        'Soothing Formula',
      ],
    ),

    Product(
      id: 'beauty_herbal_shampoo',
      name: 'Herbal Shampoo',
      subtitle: 'Shikakai Blend - 15 Raw Materials',
      description:
          'Traditional shikakai-based herbal shampoo made from 15 natural herbs. '
          'Gently cleanses while nourishing the scalp and strengthening hair from roots. '
          'Free from SLS, parabens, and harsh chemicals.',
      category: ProductCategory.beauty,
      imageEmoji: '🌺',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        '15 Herbal Ingredients',
        'Shikakai Base',
        'SLS-Free',
        'Strengthens Hair',
        'Reduces Hair Fall',
      ],
    ),

    Product(
      id: 'beauty_organic_dye',
      name: 'Organic Hair Dye Powder',
      subtitle: 'Chemical-free Natural Hair Colour',
      description:
          '100% organic hair dye made from natural plant-based ingredients. '
          'Covers grey hair naturally while conditioning and strengthening. '
          'No ammonia, no peroxide, no harsh chemicals — safe for sensitive scalps.',
      category: ProductCategory.beauty,
      imageEmoji: '🎨',
      variants: [
        ProductVariant(weight: 'Contact for pricing', price: 0),
      ],
      highlights: [
        'No Ammonia',
        'No Peroxide',
        'Covers Greys',
        'Conditions Hair',
        'Safe for Sensitive Scalps',
      ],
    ),

    // ─── GIFT COMBOS ─────────────────────────────────────────────────────────

    Product(
      id: 'gift_newborn_mom',
      name: 'New Born Baby & Mom Combo',
      subtitle: 'Special Postpartum Care Gift',
      description:
          'A thoughtfully curated combo for new mothers and their precious babies. '
          'Includes traditional postpartum care products that have been trusted by '
          'generations of Tamil families. The perfect gift for baby showers and new arrivals.',
      category: ProductCategory.giftCombos,
      imageEmoji: '👶',
      badge: 'Special Gift',
      variants: [
        ProductVariant(weight: 'Combo Pack', price: 1500),
      ],
      highlights: [
        'Postpartum Care',
        'Baby-safe Products',
        'Traditional Recipes',
        'Beautifully Packed',
        'Perfect Baby Shower Gift',
      ],
    ),

    Product(
      id: 'gift_magic_combo',
      name: 'Magic Combo',
      subtitle: 'Health & Beauty Bundle',
      description:
          'A magical combination of our best-selling health and beauty products. '
          'An ideal gift for health-conscious friends and family members. '
          'Beautifully packaged with love.',
      category: ProductCategory.giftCombos,
      imageEmoji: '✨',
      variants: [
        ProductVariant(weight: 'Combo Pack', price: 800),
      ],
      highlights: [
        'Bestseller Bundle',
        'Health + Beauty',
        'Gift Wrapped',
        'Great Value',
      ],
    ),

    Product(
      id: 'gift_kids_combo',
      name: 'Kids Combo',
      subtitle: 'Nutrition & Care for Little Ones',
      description:
          'A specially designed combo for kids with nutritious health mixes and '
          'gentle natural care products. Everything in this combo is kid-safe, '
          'natural, and designed to support healthy growth.',
      category: ProductCategory.giftCombos,
      imageEmoji: '🧒',
      variants: [
        ProductVariant(weight: 'Combo Pack', price: 1000),
      ],
      highlights: [
        'Kid-safe Products',
        'Nutritious Health Mix',
        'Gentle Skincare',
        'Fun Packaging',
        'Growth Support',
      ],
    ),

    Product(
      id: 'gift_elegant_combo',
      name: 'Elegant Combo',
      subtitle: 'Classic Beauty Essentials',
      description:
          'An elegant collection of traditional beauty essentials for the modern woman. '
          'Timeless recipes, pure ingredients, and beautiful packaging make this '
          'the perfect gifting choice for any occasion.',
      category: ProductCategory.giftCombos,
      imageEmoji: '💐',
      variants: [
        ProductVariant(weight: 'Combo Pack', price: 500),
      ],
      highlights: [
        'Traditional Beauty',
        'Pure Ingredients',
        'Elegant Packaging',
        'All Occasions',
      ],
    ),

    Product(
      id: 'gift_dark_spot',
      name: 'Dark Spot & Pimple Care Combo',
      subtitle: 'Targeted Skin Treatment',
      description:
          'A targeted skincare combo using traditional herbal remedies for dark spots and '
          'acne-prone skin. Natural, effective, and gentle — backed by generations of '
          'traditional knowledge.',
      category: ProductCategory.giftCombos,
      imageEmoji: '🌟',
      variants: [
        ProductVariant(weight: 'Combo Pack', price: 800),
      ],
      highlights: [
        'Targets Dark Spots',
        'Pimple Care',
        'Natural Treatment',
        'No Harsh Chemicals',
        'Visible Results',
      ],
    ),

    Product(
      id: 'gift_lovely_day',
      name: 'Lovely Day Combo',
      subtitle: 'Self-care Gift Set',
      description:
          'Start every day feeling lovely with this curated self-care combo. '
          'A thoughtful blend of natural products to brighten mornings and '
          'pamper yourself or your loved ones.',
      category: ProductCategory.giftCombos,
      imageEmoji: '🌸',
      variants: [
        ProductVariant(weight: 'Combo Pack', price: 500),
      ],
      highlights: [
        'Daily Self-care',
        'Natural Products',
        'Mood Lifting',
        'Perfect Gift',
        'Lovely Packaging',
      ],
    ),
  ];

  static List<Product> getByCategory(ProductCategory category) {
    return products.where((p) => p.category == category).toList();
  }

  static List<Product> search(String query) {
    final q = query.toLowerCase();
    return products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.subtitle.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.ingredients.any((i) => i.toLowerCase().contains(q)))
        .toList();
  }

  static List<Product> getFeatured() {
    return products
        .where((p) =>
            p.badge != null &&
            p.category != ProductCategory.preBooking)
        .toList();
  }
}
