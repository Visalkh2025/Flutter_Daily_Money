import 'package:daily_money/View/Home/Screens/home_screen.dart';
import 'package:daily_money/View/Profile/main/profile_screen.dart';
import 'package:daily_money/View/Statistic/statistics_screen.dart';
import 'package:daily_money/View/Wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_money/Config/routes/routes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeScreen(),
    StatisticsScreen(),
    // Add other screens here for the other tabs
    WalletScreen(),// Placeholder for Wallet
    ProfileScreen(), // Placeholder for Profile
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addTransaction),
        backgroundColor: Colors.black,
        elevation: 4,
        shape: const CircleBorder(),
        mini: false,
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.grey[400],
        elevation: 20,
        shadowColor: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(Icons.home_filled, 0),
            _buildNavIcon(Icons.pie_chart_outline, 1),
            const SizedBox(width: 48),
            _buildNavIcon(Icons.account_balance_wallet_outlined, 2),
            _buildNavIcon(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.black : Colors.grey[400],
        size: 26,
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
