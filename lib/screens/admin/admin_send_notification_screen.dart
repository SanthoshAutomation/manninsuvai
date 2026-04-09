import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';

class AdminSendNotificationScreen extends StatefulWidget {
  const AdminSendNotificationScreen({super.key});

  @override
  State<AdminSendNotificationScreen> createState() =>
      _AdminSendNotificationScreenState();
}

class _AdminSendNotificationScreenState
    extends State<AdminSendNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  bool _sending = false;

  // Pre-built templates
  static const List<Map<String, String>> _templates = [
    {
      'label': 'New Product',
      'title': '🌾 New Product Available!',
      'body': 'We\'ve added a new product to our collection. Check it out now!',
    },
    {
      'label': 'Flash Sale',
      'title': '🔥 Flash Sale — Limited Time!',
      'body': 'Special discounts on selected items. Shop now before they\'re gone!',
    },
    {
      'label': 'Back in Stock',
      'title': '✅ Back in Stock!',
      'body': 'Your favourite product is available again. Order now!',
    },
    {
      'label': 'Festival Offer',
      'title': '🎉 Festival Special Offer',
      'body': 'Celebrate with our exclusive festival combo packs. Limited stock!',
    },
    {
      'label': 'Order Reminder',
      'title': '🛒 Don\'t Forget Your Order!',
      'body': 'You haven\'t placed an order recently. Restock your health mixes!',
    },
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Send Notification',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoBanner(),
            const SizedBox(height: 16),
            _buildTemplates(),
            const SizedBox(height: 20),
            _buildFormCard(),
            const SizedBox(height: 20),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondaryLighter,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('📢', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bulk Push Notification',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'Sent to ALL users via Firebase FCM through your Hostinger server. '
                  'Make sure firebase-service-account.json is uploaded to the server.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Templates',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _templates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final t = _templates[i];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _titleCtrl.text = t['title']!;
                    _bodyCtrl.text = t['body']!;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    t['label']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Notification Title *',
                hintText: '🌾 New Arrivals!',
              ),
              style: GoogleFonts.poppins(fontSize: 14),
              validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _bodyCtrl,
              decoration: const InputDecoration(
                labelText: 'Message *',
                hintText: 'Write your message here...',
              ),
              style: GoogleFonts.poppins(fontSize: 13),
              maxLines: 4,
              validator: (v) => v == null || v.isEmpty ? 'Message is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _imageUrlCtrl,
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                hintText: 'https://example.com/image.jpg',
              ),
              style: GoogleFonts.poppins(fontSize: 13),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _sending ? null : _sendNotification,
        icon: _sending
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.send_rounded),
        label: Text(
          _sending ? 'Sending...' : 'Send to All Users',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _sending ? Colors.grey : AppColors.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    final error = await NotificationService.sendBulkNotification(
      title: _titleCtrl.text.trim(),
      body: _bodyCtrl.text.trim(),
      imageUrl: _imageUrlCtrl.text.trim().isEmpty ? null : _imageUrlCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _sending = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notification sent to all users! 🎉', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
      ));
      _titleCtrl.clear();
      _bodyCtrl.clear();
      _imageUrlCtrl.clear();
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Send Failed', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          content: Text(error, style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK', style: GoogleFonts.poppins(color: AppColors.secondary)),
            ),
          ],
        ),
      );
    }
  }
}
