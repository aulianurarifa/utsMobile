import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData(useMaterial3: true);
    final TextTheme y2kTextTheme =
        GoogleFonts.audiowideTextTheme(base.textTheme).apply(
      bodyColor: const Color(0xFF5F5FA8),
      displayColor: const Color(0xFF5F5FA8),
    );
    final ThemeData theme = base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF9EC6),
        secondary: const Color(0xFFAED7FF),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF6FC),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFFFE4F0),
        foregroundColor: Color(0xFF6F8CCF),
        titleTextStyle: GoogleFonts.audiowide(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6F8CCF),
          letterSpacing: 0.8,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFFFF88BB),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      textTheme: y2kTextTheme,
    );

    return MaterialApp(
      title: 'My Dashboard App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
