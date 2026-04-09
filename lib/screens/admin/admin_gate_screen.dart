import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';
import '../../theme/app_theme.dart';
import 'admin_dashboard_screen.dart';

/// PIN-protected entry to the admin area.
/// No login accounts — just a 4-digit PIN stored in SharedPreferences.
class AdminGateScreen extends StatefulWidget {
  const AdminGateScreen({super.key});

  @override
  State<AdminGateScreen> createState() => _AdminGateScreenState();
}

class _AdminGateScreenState extends State<AdminGateScreen> {
  String _enteredPin = '';
  bool _error = false;

  void _onKey(String digit) {
    if (_enteredPin.length >= 4) return;
    setState(() {
      _enteredPin += digit;
      _error = false;
    });
    if (_enteredPin.length == 4) _verify();
  }

  void _onDelete() {
    if (_enteredPin.isEmpty) return;
    setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
  }

  Future<void> _verify() async {
    final prefs = await SharedPreferences.getInstance();
    final correctPin =
        prefs.getString(AppConfigKeys.adminPin) ?? AppConfigKeys.defaultAdminPin;

    if (_enteredPin == correctPin) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
      }
    } else {
      setState(() {
        _enteredPin = '';
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Admin Access',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text('🔐', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              'Enter Admin PIN',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Default PIN is 1234',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white60),
            ),
            const SizedBox(height: 36),
            // PIN dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _error
                        ? Colors.red
                        : filled
                            ? AppColors.primary
                            : Colors.white30,
                    border: Border.all(
                      color: _error ? Colors.red : Colors.white54,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),
            if (_error) ...[
              const SizedBox(height: 12),
              Text(
                'Wrong PIN. Try again.',
                style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 13),
              ),
            ],
            const SizedBox(height: 40),
            // Numpad
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final row in [
                      ['1', '2', '3'],
                      ['4', '5', '6'],
                      ['7', '8', '9'],
                      ['', '0', '⌫'],
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: row.map((key) => _buildKey(key)).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String key) {
    if (key.isEmpty) return const SizedBox(width: 72, height: 72);

    return GestureDetector(
      onTap: () => key == '⌫' ? _onDelete() : _onKey(key),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.12),
        ),
        child: Center(
          child: Text(
            key,
            style: GoogleFonts.poppins(
              fontSize: key == '⌫' ? 22 : 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
