import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  Color get _cardColor {
    switch (product.category) {
      case ProductCategory.healthMix:
        return AppColors.secondaryLighter;
      case ProductCategory.teaBeverages:
        return AppColors.amberLight;
      case ProductCategory.beauty:
        return AppColors.pinkLight;
      case ProductCategory.giftCombos:
        return const Color(0xFFF3E5F5);
      case ProductCategory.preBooking:
        return const Color(0xFFE3F2FD);
    }
  }

  Color get _accentColor {
    switch (product.category) {
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Center(
            child: Text(
              product.imageEmoji,
              style: const TextStyle(fontSize: 64),
            ),
          ),
        ),
        if (product.badge != null)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.badge!,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
        if (product.isPreBooking)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.preBook,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Pre-book',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            product.subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceText(),
              _buildAddButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceText() {
    if (product.minPrice <= 0) {
      return Text(
        'Contact Us',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMedium,
        ),
      );
    }

    if (product.variants.length == 1) {
      return Text(
        '₹${product.minPrice.toStringAsFixed(0)}',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textLight,
          ),
        ),
        Text(
          '₹${product.minPrice.toStringAsFixed(0)}',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        final firstPricedVariant = product.variants.firstWhere(
          (v) => v.price > 0,
          orElse: () => product.variants.first,
        );
        final isInCart = cart.isInCart(product.id, firstPricedVariant.weight);

        return GestureDetector(
          onTap: () {
            if (!isInCart) {
              cart.addItem(product, firstPricedVariant);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added to cart!',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isInCart ? AppColors.secondaryLighter : AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isInCart ? Icons.check : Icons.add,
              color: isInCart ? AppColors.secondary : Colors.white,
              size: 18,
            ),
          ),
        );
      },
    );
  }
}
