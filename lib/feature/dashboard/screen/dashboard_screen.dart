import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../chat/screen/chat_screen.dart';
import '../../favorite/screen/favorite_screen.dart';
import '../../gift/screen/gift_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../profile/screen/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final _screens =  [
    HomeScreen(),
    GiftScreen(),
    FavoriteScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],

      bottomNavigationBar: SafeArea(
        child:  Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.08),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GNav(
            gap: 8,
            iconSize: 26,
            tabBorderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: Colors.transparent,
            activeColor: Colors.white,
            color: Colors.grey,
            tabBackgroundColor: Colors.pinkAccent,
            selectedIndex: _currentIndex,

            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },

            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: "Home",
              ),
              GButton(
                icon: Icons.card_giftcard_outlined,
                text: "Gift",
              ),
              GButton(
                icon: Icons.favorite_border,
                text: "Favorite",
              ),
              GButton(
                icon: Icons.chat_bubble_outline,
                text: "Chat",
              ),
              GButton(
                icon: Icons.person_outline,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
