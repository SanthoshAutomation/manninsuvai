import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';
import '../../models/product.dart';
import '../../providers/products_provider.dart';
import '../../theme/app_theme.dart';
import 'admin_product_form_screen.dart';
import 'admin_send_notification_screen.dart';
import 'admin_settings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  ProductCategory? _filterCategory;
  bool _isSaving = false;

  // Web stats
  int? _visitsToday;
  int? _visitsTotal;
  int? _notifSubscribers;
  bool _statsLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _statsLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final readUrl = prefs.getString(AppConfigKeys.productsReadUrl) ?? '';
      final apiKey  = prefs.getString(AppConfigKeys.serverApiKey) ?? '';
      if (readUrl.isEmpty || apiKey.isEmpty) {
        setState(() => _statsLoading = false);
        return;
      }

      final statsUrl = readUrl.contains('api.php')
          ? '${readUrl}?action=stats'
          : readUrl;

      final response = await http.get(
        Uri.parse(statsUrl),
        headers: {'Authorization': 'Bearer $apiKey'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _visitsToday       = data['web_visits_today']         as int?;
            _visitsTotal       = data['web_visits_total']         as int?;
            _notifSubscribers  = data['notification_subscribers'] as int?;
          });
        }
      }
    } catch (_) {
      // Stats are optional — silent failure.
    } finally {
      if (mounted) setState(() => _statsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: AppColors.secondary,
        actions: [
          IconButton(
            tooltip: 'Send Notification',
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminSendNotificationScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          final products = _filterCategory == null
              ? provider.products
              : provider.getByCategory(_filterCategory!);

          return Column(
            children: [
              _buildSummaryBar(provider),
              _buildStatsCard(),
              _buildCategoryFilter(),
              Expanded(
                child: products.isEmpty
                    ? _buildEmpty()
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) => _buildProductTile(ctx, products[i], provider),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Save to server button
          FloatingActionButton.extended(
            heroTag: 'save',
            onPressed: _isSaving ? null : _saveToServer,
            backgroundColor: _isSaving ? Colors.grey : AppColors.preBook,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined, color: Colors.white),
            label: Text(
              _isSaving ? 'Saving...' : 'Save to Server',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          // Add product button
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _openForm(context, null),
            backgroundColor: AppColors.secondary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final String today = _statsLoading
        ? '...'
        : (_visitsToday == null ? '—' : '$_visitsToday');
    final String total = _statsLoading
        ? '...'
        : (_visitsTotal == null ? '—' : '$_visitsTotal');
    final String subs = _statsLoading
        ? '...'
        : (_notifSubscribers == null ? '—' : '$_notifSubscribers');

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondaryLighter),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _statItem('👁', 'Today', today)),
          _statDivider(),
          Expanded(child: _statItem('📊', 'Total visits', total)),
          _statDivider(),
          Expanded(child: _statItem('🔔', 'Subscribers', subs)),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh, size: 18, color: AppColors.textLight),
            onPressed: _fetchStats,
          ),
        ],
      ),
    );
  }

  Widget _statItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 40, color: AppColors.secondaryLighter,
        margin: const EdgeInsets.symmetric(horizontal: 8));
  }

  Widget _buildSummaryBar(ProductsProvider provider) {
    final total = provider.products.length;
    final outOfStock = provider.products.where((p) => !p.inStock).length;
    final discounted = provider.products
        .where((p) => p.variants.any((v) => v.hasDiscount))
        .length;

    return Container(
      color: AppColors.secondary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          _summaryChip('$total Products', Icons.inventory_2_outlined),
          const SizedBox(width: 12),
          _summaryChip('$outOfStock Out of stock', Icons.remove_shopping_cart_outlined,
              color: Colors.redAccent),
          const SizedBox(width: 12),
          _summaryChip('$discounted On sale', Icons.local_offer_outlined,
              color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _summaryChip(String label, IconData icon, {Color color = Colors.white70}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 12, color: color)),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final cats = [null, ...ProductCategory.values];
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: cats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) {
            final cat = cats[i];
            final selected = cat == _filterCategory;
            return GestureDetector(
              onTap: () => setState(() => _filterCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppColors.secondary : AppColors.secondaryLighter,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat == null ? 'All' : '${cat.emoji} ${cat.displayName}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.secondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductTile(
      BuildContext context, Product product, ProductsProvider provider) {
    final hasDiscount = product.variants.any((v) => v.hasDiscount);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.secondaryLighter,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(product.imageEmoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            if (!product.inStock)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 10, color: Colors.white),
                ),
              ),
          ],
        ),
        title: Text(
          product.name,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: product.inStock ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.category.displayName,
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
            ),
            Row(
              children: [
                Text(
                  product.variants.isEmpty
                      ? 'No variants'
                      : 'From ₹${product.minPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                if (hasDiscount) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SALE',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stock toggle
            IconButton(
              tooltip: product.inStock ? 'Mark out of stock' : 'Mark in stock',
              icon: Icon(
                product.inStock ? Icons.check_circle : Icons.cancel_outlined,
                color: product.inStock ? AppColors.secondary : Colors.red,
                size: 22,
              ),
              onPressed: () => provider.toggleProductStock(product.id),
            ),
            // Edit
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined, color: AppColors.textMedium, size: 20),
              onPressed: () => _openForm(context, product),
            ),
            // Delete
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () => _confirmDelete(context, product, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📦', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            'No products yet',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first product',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, Product? product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminProductFormScreen(product: product),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, Product product, ProductsProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Product?', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text(
          'Remove "${product.name}" from the catalogue?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMedium)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      provider.removeProduct(product.id);
    }
  }

  Future<void> _saveToServer() async {
    setState(() => _isSaving = true);
    try {
      final provider = context.read<ProductsProvider>();
      await provider.saveToServer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Saved to server!', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
