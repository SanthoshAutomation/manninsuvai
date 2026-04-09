import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../theme/app_theme.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<AppOrder> _orders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final orders = await OrderService.fetchOrders(limit: 100);
      if (mounted) setState(() { _orders = orders; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order History',
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.secondary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _orders.isEmpty
                  ? _buildEmpty()
                  : _buildList(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 60, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Could not load orders', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(_error!, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLight),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _load,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
              child: Text('Retry', style: GoogleFonts.poppins(color: Colors.white)),
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
          const Text('📋', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('No orders yet', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,
              color: AppColors.textMedium)),
          const SizedBox(height: 8),
          Text('Orders will appear here once customers place them',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textLight),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildList() {
    // Summary totals
    final totalOrders = _orders.length;
    final totalRevenue = _orders.fold<double>(0, (s, o) => s + o.subtotal);
    final webOrders = _orders.where((o) => o.platform == 'web').length;

    return Column(
      children: [
        // Summary bar
        Container(
          color: AppColors.secondary,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              _chip('$totalOrders Orders'),
              const SizedBox(width: 16),
              _chip('₹${totalRevenue.toStringAsFixed(0)} Revenue'),
              const SizedBox(width: 16),
              _chip('$webOrders Web'),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _buildOrderCard(_orders[i]),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label) => Text(label,
      style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70));

  Widget _buildOrderCard(AppOrder order) {
    final time = '${order.placedAt.day}/${order.placedAt.month}/${order.placedAt.year} '
        '${order.placedAt.hour.toString().padLeft(2, '0')}:'
        '${order.placedAt.minute.toString().padLeft(2, '0')}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: order.platform == 'web'
                        ? AppColors.preBook.withOpacity(0.15)
                        : AppColors.secondaryLighter,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.platform == 'web' ? '🌐 Web' : '📱 App',
                    style: GoogleFonts.poppins(fontSize: 11,
                        color: order.platform == 'web' ? AppColors.preBook : AppColors.secondary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                Text(time, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLight)),
                const Spacer(),
                if (order.subtotal > 0)
                  Text('₹${order.subtotal.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w800,
                          color: AppColors.secondary)),
              ],
            ),
            const SizedBox(height: 10),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '• ${item.productName} (${item.variantWeight})',
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark),
                        ),
                      ),
                      Text('×${item.quantity}',
                          style: GoogleFonts.poppins(fontSize: 13,
                              fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                      const SizedBox(width: 8),
                      if (item.price > 0)
                        Text('₹${item.total.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMedium)),
                    ],
                  ),
                )),
            if (order.deliveryCharge > 0) ...[
              const Divider(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLight)),
                  Text('₹${order.deliveryCharge.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
