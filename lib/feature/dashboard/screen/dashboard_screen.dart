import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../chat/screen/chat_member_list_screen.dart';
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
    ChatMemberListScreen(),
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



      floatingActionButton:
      _currentIndex ==3 ? SizedBox.shrink():
      Container(
        width: 63,  // Reduced from 70 to 63
        height: 63, // Reduced from 70 to 63
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink.shade400,
              Colors.pink.shade600,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer circular progress
            SizedBox(
              width: 63,  // Reduced from 70 to 63
              height: 63, // Reduced from 70 to 63
              child: CircularProgressIndicator(
                value: 0.75, // 75% completion - change this dynamically
                strokeWidth: 3.6, // Reduced from 4 to 3.6
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            // Inner circle
            Container(
              width: 55,  // Reduced from 58 to 52
              height: 55, // Reduced from 58 to 52
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '75%', // Change this dynamically
                    style: TextStyle(
                      fontSize: 14.4, // Reduced from 16 to 14.4
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade600,
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 8.1, // Reduced from 9 to 8.1
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
