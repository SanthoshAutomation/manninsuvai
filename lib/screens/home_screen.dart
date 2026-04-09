import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:badges/badges.dart' as badges;
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import 'products_screen.dart';
import 'cart_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int _bannerIndex = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Nutri Rice Health Mix',
      'subtitle': '30+ Traditional Rice Varieties & More',
      'emoji': '🍚',
      'color': AppColors.secondaryLighter,
      'label': 'From ₹480',
    },
    {
      'title': 'Multi Millets Mix',
      'subtitle': 'Ancient Grains for Modern Wellness',
      'emoji': '🌾',
      'color': AppColors.amberLight,
      'label': 'From ₹455',
    },
    {
      'title': 'Natural Beauty Care',
      'subtitle': 'Azhagiya Amudham - Traditional Herbal',
      'emoji': '🌸',
      'color': AppColors.pinkLight,
      'label': 'Explore Now',
    },
    {
      'title': 'Premium Tea',
      'subtitle': 'From 7th Heaven, Valparai',
      'emoji': '🍵',
      'color': Color(0xFFF3E5D8),
      'label': 'From ₹210/kg',
    },
    {
      'title': 'Gift Combos',
      'subtitle': 'For New Mom, Kids & Loved Ones',
      'emoji': '🎁',
      'color': Color(0xFFF3E5F5),
      'label': 'From ₹500',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Health Mixes',
      'emoji': '🌾',
      'color': AppColors.healthMix,
      'bgColor': AppColors.secondaryLighter,
      'category': ProductCategory.healthMix,
      'count': '3 Products',
    },
    {
      'title': 'Tea & Beverages',
      'emoji': '🍵',
      'color': AppColors.teaBev,
      'bgColor': AppColors.amberLight,
      'category': ProductCategory.teaBeverages,
      'count': '7 Products',
    },
    {
      'title': 'Natural Beauty',
      'emoji': '🌸',
      'color': AppColors.beauty,
      'bgColor': AppColors.pinkLight,
      'category': ProductCategory.beauty,
      'count': '7 Products',
    },
    {
      'title': 'Gift Combos',
      'emoji': '🎁',
      'color': AppColors.gifts,
      'bgColor': const Color(0xFFF3E5F5),
      'category': ProductCategory.giftCombos,
      'count': '6 Combos',
    },
    {
      'title': 'Pre-Booking',
      'emoji': '📋',
      'color': AppColors.preBook,
      'bgColor': const Color(0xFFE3F2FD),
      'category': ProductCategory.preBooking,
      'count': '4 Items',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeTab(),
          const ProductsScreen(),
          const CartScreen(),
          const AboutScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: _currentNavIndex,
              onTap: (index) => setState(() => _currentNavIndex = index),
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.secondary,
              unselectedItemColor: AppColors.textLight,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  activeIcon: Icon(Icons.grid_view),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: badges.Badge(
                    showBadge: cart.itemCount > 0,
                    badgeContent: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.pink),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  activeIcon: badges.Badge(
                    showBadge: cart.itemCount > 0,
                    badgeContent: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.pink),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: 'Cart',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  activeIcon: Icon(Icons.info),
                  label: 'About',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(child: _buildBannerCarousel()),
        SliverToBoxAdapter(child: _buildCategoriesSection()),
        SliverToBoxAdapter(child: _buildFeaturedSection()),
        SliverToBoxAdapter(child: _buildWhyChooseUs()),
        SliverToBoxAdapter(child: _buildContactBanner()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      snap: true,
      backgroundColor: AppColors.secondary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌾', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text('Mannin Suvai',
                style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white)),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        Consumer<CartProvider>(
          builder: (ctx, cart, _) => badges.Badge(
            showBadge: cart.itemCount > 0,
            badgeContent: Text('${cart.itemCount}',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.pink),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              onPressed: () => setState(() => _currentNavIndex = 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            viewportFraction: 1.0,
            onPageChanged: (index, _) => setState(() => _bannerIndex = index),
          ),
          items: _banners.map(_buildBannerItem).toList(),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _bannerIndex,
          count: _banners.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.secondary,
            dotColor: AppColors.secondary.withOpacity(0.25),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBannerItem(Map<String, dynamic> banner) {
    return GestureDetector(
      onTap: () => setState(() => _currentNavIndex = 1),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: banner['color'],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Mannin Suvai',
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Text(banner['title'],
                        style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(banner['subtitle'],
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMedium), maxLines: 2),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(banner['label'],
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Text(banner['emoji'], style: const TextStyle(fontSize: 72)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shop by Category',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              TextButton(
                onPressed: () => setState(() => _currentNavIndex = 1),
                child: Text('See All',
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return CategoryCard(
                  title: cat['title'],
                  emoji: cat['emoji'],
                  color: cat['color'],
                  bgColor: cat['bgColor'],
                  count: cat['count'],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductsScreen(initialCategory: cat['category']),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Consumer<ProductsProvider>(
      builder: (ctx, provider, _) {
        final featured = provider.getFeatured();
        if (featured.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Featured Products',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text('Our most loved natural products',
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMedium)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: featured.length,
                itemBuilder: (context, index) => ProductCard(
                  product: featured[index],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductsScreen(initialProduct: featured[index])),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _currentNavIndex = 1),
                  icon: const Icon(Icons.grid_view_outlined),
                  label: Text('View All Products', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWhyChooseUs() {
    final reasons = [
      {'icon': '🌿', 'title': 'All Natural', 'desc': 'No preservatives or additives'},
      {'icon': '🏠', 'title': 'Homemade', 'desc': 'Made fresh in small batches'},
      {'icon': '✅', 'title': 'FSSAI Certified', 'desc': 'Reg. 22426379000200'},
      {'icon': '🚀', 'title': 'Fast Delivery', 'desc': 'WhatsApp orders accepted'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, Color(0xFF33691E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Why Choose Us?',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: reasons.map((r) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(r['icon']!, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(r['title']!,
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.white)),
                        Text(r['desc']!,
                            style: GoogleFonts.poppins(fontSize: 9, color: Colors.white70), maxLines: 2),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text('🛒 Order via WhatsApp',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.secondary)),
          const SizedBox(height: 8),
          Text('8754077890 & 9994846501',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.secondary), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('manninsuvai25@gmail.com | @manninsuvai25',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMedium), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text('🎁 Exciting Gift Combos for New MOM, Kids & Your Loved Ones!',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
