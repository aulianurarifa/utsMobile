import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE4F6), Color(0xFFCCE4FF), Color(0xFFFFF0F8)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 164,
                height: 164,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD6EB), Color(0xFFAED7FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.45),
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Judul Aplikasi
              Text(
                'Lovely Dashbord 🎀',
                style: GoogleFonts.audiowide(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6F8CCF),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),

              // NIM
              Text(
                '152022046',
                style: GoogleFonts.audiowide(
                  fontSize: 18,
                  color: const Color(0xFF8A6CC0),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 5),

              // Nama
              Text(
                'Nama: Aulia Nur Arifa 💝',
                style: GoogleFonts.audiowide(
                  fontSize: 18,
                  color: const Color(0xFF8A6CC0),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 5),

              Text(
                'Tanggal Lahir: 17 Juni 2004',
                style: GoogleFonts.audiowide(
                  fontSize: 16,
                  color: const Color(0xFF9A7DD6),
                  letterSpacing: 0.75,
                ),
              ),
              const SizedBox(height: 50),

              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6F8CCF)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
