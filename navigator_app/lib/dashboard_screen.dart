import 'package:flutter/material.dart';
import 'pages/dashboard_home_page.dart';
import 'pages/biodata_page.dart';
import 'pages/kontak_page.dart';
import 'pages/kalkulator_page.dart';
import 'pages/cuaca_page.dart';
import 'pages/berita_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // List of pages/fragments
  final List<Widget> _pages = [
    const DashboardHomePage(),
    const BiodataPage(),
    const KontakPage(),
    const KalkulatorPage(),
    const CuacaPage(),
    const BeritaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FC),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFE5F4),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF7FBE),
        unselectedItemColor: const Color(0xFFA3BDFE),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Biodata'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Kontak'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Cuaca'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Berita'),
        ],
      ),
    );
  }
}
