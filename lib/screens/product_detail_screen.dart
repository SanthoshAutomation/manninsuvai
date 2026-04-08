import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _selectedVariantIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color get _categoryColor {
    switch (widget.product.category) {
      case ProductCategory.healthMix:
        return AppColors.healthMix;
      case ProductCategory.teaBeverages:
        return AppColors.teaBev;
      case ProductCategory.beauty:
        return AppColors.beauty;
      case ProductCategory.giftCombos:
        return AppColors.gifts;
      case ProductCategory.preBooking:
        return AppColors.preBook;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final selectedVariant = product.variants[_selectedVariantIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(product),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductHeader(product),
                _buildVariantSelector(product),
                _buildTabSection(product),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(product, selectedVariant),
    );
  }

  Widget _buildSliverAppBar(Product product) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: _categoryColor,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _categoryColor.withOpacity(0.3),
                _categoryColor.withOpacity(0.6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  product.imageEmoji,
                  style: const TextStyle(fontSize: 100),
                ),
                if (product.badge != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.badge!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductHeader(Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _categoryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${product.category.emoji} ${product.category.displayName}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _categoryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMedium,
              height: 1.6,
            ),
          ),
          if (product.highlights.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.highlights.map((h) => _buildHighlightChip(h)).toList(),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHighlightChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryLighter,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.secondary, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSelector(Product product) {
    if (product.variants.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Size / Variant',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(product.variants.length, (index) {
              final variant = product.variants[index];
              final isSelected = index == _selectedVariantIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedVariantIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        variant.weight,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      if (variant.price > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          '₹${variant.price.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white70 : AppColors.secondary,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 2),
                        Text(
                          'On Request',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isSelected ? Colors.white70 : AppColors.textLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(Product product) {
    final hasIngredients = product.ingredients.isNotEmpty;
    final tabCount = hasIngredients ? 2 : 1;
    if (_tabController.length != tabCount) {
      _tabController = TabController(length: tabCount, vsync: this);
    }

    return Column(
      children: [
        Container(
          color: AppColors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.secondary,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.textLight,
            labelStyle: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
            tabs: [
              const Tab(text: 'Details'),
              if (hasIngredients) const Tab(text: 'Ingredients'),
            ],
          ),
        ),
        SizedBox(
          height: hasIngredients ? 400 : 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(product),
              if (hasIngredients) _buildIngredientsTab(product),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTab(Product product) {
    final infoItems = [
      {
        'label': 'Brand',
        'value': product.category == ProductCategory.beauty
            ? 'Azhagiya Amudham'
            : 'Mannin Suvai',
      },
      {
        'label': 'Category',
        'value': product.category.displayName,
      },
      {
        'label': 'Type',
        'value': product.isPreBooking ? 'Pre-booking Only' : 'Regular Stock',
      },
      {
        'label': 'Preservatives',
        'value': 'None',
      },
      {
        'label': 'FSSAI Reg.',
        'value': '22426379000200',
      },
      {
        'label': 'Address',
        'value': 'Sattur Taluk, Virudhunagar, Tamil Nadu 626203',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ...infoItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    item['label']!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(' : ', style: TextStyle(color: AppColors.textLight)),
                Expanded(
                  child: Text(
                    item['value']!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (product.isPreBooking) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.preBook.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.preBook.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.preBook, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This product is available on pre-booking orders only. '
                    'Please contact us via WhatsApp to place an order.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.preBook,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIngredientsTab(Product product) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: product.ingredients.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.secondaryLighter,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                product.ingredients[index],
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Product product, ProductVariant selectedVariant) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        final isInCart = cart.isInCart(product.id, selectedVariant.weight);
        final priceText = selectedVariant.price > 0
            ? '₹${selectedVariant.price.toStringAsFixed(0)}'
            : 'Price on request';

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    priceText,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isInCart) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Already in cart!',
                            style: GoogleFonts.poppins(),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.secondary,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } else {
                      cart.addItem(product, selectedVariant);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.name} added to cart!',
                            style: GoogleFonts.poppins(),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.secondary,
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: AppColors.primary,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    isInCart ? Icons.check : Icons.add_shopping_cart,
                  ),
                  label: Text(
                    isInCart ? 'Added to Cart' : 'Add to Cart',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart
                        ? AppColors.secondaryLighter
                        : AppColors.secondary,
                    foregroundColor: isInCart ? AppColors.secondary : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
