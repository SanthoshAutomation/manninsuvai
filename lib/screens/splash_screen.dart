import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Brand Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🌾',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  )
                  .fade(duration: 500.ms),

              const SizedBox(height: 32),

              // Brand name
              Text(
                'Mannin Suvai',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  letterSpacing: 1.2,
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              Text(
                'மண்ணின் சுவை',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 16),

              // Tagline
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'From our soil to your soul',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 16),

              Text(
                'பாரம்பரிய சுவை, பரிசுத்தமான வாழ்க்கை',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.secondary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              )
                  .animate(delay: 900.ms)
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 60),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  strokeWidth: 3,
                ),
              )
                  .animate(delay: 1.seconds)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // FSSAI badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'FSSAI Reg: 22426379000200',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  .animate(delay: 1200.ms)
                  .fadeIn(duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
