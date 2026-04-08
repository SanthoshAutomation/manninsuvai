import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.secondary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBrandHeader(),
            _buildAboutSection(),
            _buildContactSection(context),
            _buildFssaiSection(),
            _buildBrandsSection(),
            _buildFollowUs(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, Color(0xFF33691E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🌾', style: TextStyle(fontSize: 44)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Mannin Suvai',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'மண்ணின் சுவை',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '"From our soil to your soul"',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'பாரம்பரிய சுவை, பரிசுத்தமான வாழ்க்கை',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white60,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Story',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Mannin Suvai was born from a deep love for traditional Tamil food wisdom '
            'and a desire to bring authentic, preservative-free homemade health mixes '
            'to modern families.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMedium,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Our products are crafted by P. Packiyalakshmi with generations of knowledge '
            'about traditional rice varieties, ancient millets, and natural herbs. '
            'Every batch is made fresh with love — no shortcuts, no chemicals, no compromise.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMedium,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We source directly from trusted farmers and bring you the true taste of '
            'our land — Mannin Suvai.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMedium,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final contacts = [
      {
        'icon': Icons.chat,
        'emoji': '💬',
        'label': 'WhatsApp Order 1',
        'value': '+91 87540 77890',
        'color': const Color(0xFF25D366),
        'action': () => _launchUrl('https://wa.me/918754077890'),
      },
      {
        'icon': Icons.chat,
        'emoji': '💬',
        'label': 'WhatsApp Order 2',
        'value': '+91 99948 46501',
        'color': const Color(0xFF25D366),
        'action': () => _launchUrl('https://wa.me/919994846501'),
      },
      {
        'icon': Icons.email_outlined,
        'emoji': '📧',
        'label': 'Email',
        'value': 'manninsuvai25@gmail.com',
        'color': AppColors.preBook,
        'action': () => _launchUrl('mailto:manninsuvai25@gmail.com'),
      },
      {
        'icon': Icons.location_on_outlined,
        'emoji': '📍',
        'label': 'Address',
        'value':
            '2/112, Samiyar Colony, Kattalampatti Post,\nSattur Taluk, Virudhunagar,\nTamil Nadu - 626203',
        'color': AppColors.brown,
        'action': null,
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Contact Us',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          ...contacts.map((c) => _buildContactTile(c)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildContactTile(Map<String, dynamic> contact) {
    return InkWell(
      onTap: contact['action'] as VoidCallback?,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (contact['color'] as Color).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  contact['emoji'] as String,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact['label'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    contact['value'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            if (contact['action'] != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textLight,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFssaiSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryLighter,
            AppColors.primary.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🏛️', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FSSAI Certified',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'Reg. ID: 22426379000200',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Valid Upto: 12-03-2031',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                Text(
                  'Issuing Authority: Virudhunagar\nIssued: 13-03-2026',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Brands',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildBrandCard(
            emoji: '🌾',
            name: 'Mannin Suvai',
            tagline: 'Traditional Homemade Health Mixes',
            description:
                'Premium health mixes made from traditional rice varieties, millets, '
                'pulses, dry fruits, and natural spices. FSSAI certified.',
            bgColor: AppColors.secondaryLighter,
            textColor: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          _buildBrandCard(
            emoji: '🌸',
            name: 'Azhagiya Amudham',
            tagline: 'Traditional Herbal Beauty Care',
            description:
                'Natural herbal beauty products using traditional recipes for skin & hair. '
                'Safe for kids & family. No chemicals, only nature.',
            bgColor: AppColors.pinkLight,
            textColor: AppColors.beauty,
          ),
          const SizedBox(height: 12),
          _buildBrandCard(
            emoji: '🍵',
            name: '7th Heaven Valparai',
            tagline: "Nature's Best Place to Taste Tea",
            description:
                'Premium tea sourced directly from the lush, pristine tea gardens of '
                'Valparai — one of the finest tea-growing regions in Tamil Nadu.',
            bgColor: AppColors.amberLight,
            textColor: AppColors.teaBev,
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard({
    required String emoji,
    required String name,
    required String tagline,
    required String description,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  tagline,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMedium,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              'Follow Us',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _launchUrl('https://www.instagram.com/manninsuvai25'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📷', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    '@manninsuvai25',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'TASTE the REAL TASTE of HOMEMADE',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textMedium,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
