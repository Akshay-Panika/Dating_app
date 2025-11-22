import 'dart:math';
import 'package:dating_app/constent/app_color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double dx = 0;
  double dy = 0;
  double angle = 0;

  IconData? actionIcon;
  Color actionColor = Colors.transparent;

  // SHOW CENTER ICON FOR BUTTON ACTION
  void showCenterAction(IconData icon, Color color) {
    setState(() {
      actionIcon = icon;
      actionColor = color;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        actionIcon = null;
      });
    });
  }

  // BUTTON ACTIONS
  void onLike() {
    showCenterAction(Icons.thumb_up, Colors.green);
    animateSwipe(1);
  }

  void onDislike() {
    showCenterAction(Icons.close, Colors.red);
    animateSwipe(-1);
  }

  void onSuperLike() {
    showCenterAction(Icons.star, Colors.purple);
  }

  void onFavorite() {
    showCenterAction(Icons.favorite, Colors.pink);
  }

  // SWIPE ANIMATION
  void animateSwipe(int direction) async {
    for (int i = 0; i < 20; i++) {
      await Future.delayed(const Duration(milliseconds: 8));
      setState(() {
        dx += direction * 20;
        angle = dx / 300;
      });
    }
    resetCard();
  }

  // RESET CARD POSITION
  void resetCard() {
    setState(() {
      dx = 0;
      dy = 0;
      angle = 0;
      actionIcon = null;
    });
  }

  // SWIPE ICON LOGIC
  IconData getSwipeIcon() {
    if (dx > 0) return Icons.thumb_up;
    if (dx < 0) return Icons.close;
    return Icons.star;
  }

  Color getSwipeColor() {
    if (dx > 0) return Colors.green;
    if (dx < 0) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            surfaceTintColor: Colors.white,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,

            title: Row(
              children: [
                // PROFILE ICON
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage("assets/image/indian-couple-celebrating-propose-day.jpg"),
                  ),
                ),

                SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dating App",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      "Find your perfect match ❤️",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            actions: [
              // Premium Crown Icon
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.workspace_premium, size: 28, color: Colors.amber),
              ),

              // Live Counter (FutureStick)
              FutureBuilder<int>(
                future: _loadOnlineCount(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.pink, size: 18),
                          SizedBox(width: 6),
                          Text(
                            snapshot.data.toString(),
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Stack(
          children: [

            // Profile Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 510),

                  // ABOUT ME
                  Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "I love travelling, photography, and exploring new food spots. "
                        "Looking for someone who is honest, caring, and loves adventures 💙",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),

                  const SizedBox(height: 20),

                  // BASIC DETAILS
                  Text(
                    'Basic Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _infoBox([
                    _infoTile(Icons.person, "Age", "24"),
                    _infoTile(Icons.height, "Height", "5'6''"),
                    _infoTile(Icons.location_on, "City", "Indore"),
                    _infoTile(Icons.school, "Education", "MBA"),
                    _infoTile(Icons.work, "Profession", "UI/UX Designer"),
                    _infoTile(Icons.favorite, "Relationship Status", "Single"),
                  ]),

                  const SizedBox(height: 20),

                  // INTERESTS
                  Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _chipBox([
                    "Travelling",
                    "Photography",
                    "Music",
                    "Netflix",
                    "Adventure",
                    "Gym",
                    "Cooking",
                  ]),

                  const SizedBox(height: 20),

                  // LIFE STYLE
                  Text(
                    'Lifestyle',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _infoBox([
                    _infoTile(Icons.local_drink, "Drinking", "No"),
                    _infoTile(Icons.smoking_rooms, "Smoking", "No"),
                    _infoTile(Icons.pets, "Pet Lover", "Yes"),
                    _infoTile(Icons.fastfood, "Diet", "Vegetarian"),
                  ]),

                  const SizedBox(height: 20),

                  // LOOKING FOR
                  Text(
                    'Looking For',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "Someone who is genuine, romantic, respectful and wants a long-term connection 💕",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Profile Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // SWIPE CARD
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        dx += details.delta.dx;
                        dy += details.delta.dy;
                        angle = dx / 500;
                        actionIcon = getSwipeIcon();
                        actionColor = getSwipeColor();
                      });
                    },
        
                    onPanEnd: (details) {
                      if (dx > 150) {
                        onLike();
                      } else if (dx < -150) {
                        onDislike();
                      } else {
                        resetCard();
                      }
                    },
        
                    child: Transform.translate(
                      offset: Offset(dx, dy),
                      child: Transform.rotate(
                        angle: angle,
                        child: Container(
                          height: 520,
                          child: Stack(
                            alignment: AlignmentGeometry.bottomCenter,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/image/indian-couple-celebrating-propose-day.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.1),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Aditi Rathod', style: TextStyle(fontSize:24,color: Colors.white,fontWeight: FontWeight.bold),),
                                          SizedBox(width: 10,),
                                          Icon(Icons.verified,color: Colors.blue,),
                                        ],
                                      ),
                                      Text('I’m looking for someone who wants to experience life to the fullest and isn’t afraid of a little adventure!', style: TextStyle(color: Colors.white),),
                                      SizedBox(height: 30,)
                                    ],
                                  ),
                                ),
                              ),
        
                              // ACTION BUTTONS
                              Positioned(
                                bottom: 20,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: onDislike,
                                      child: _circleBtn(Icons.close, Colors.white, Colors.black),
                                    ),
                                    const SizedBox(width: 12),
        
                                    GestureDetector(
                                      onTap: onSuperLike,
                                      child: _circleBtn(Icons.star, Colors.purple.shade100, Colors.purple),
                                    ),
                                    const SizedBox(width: 12),
        
                                    GestureDetector(
                                      onTap: onFavorite,
                                      child: _circleBtn(Icons.favorite, Colors.white, Colors.pink),
                                    ),
                                    const SizedBox(width: 12),
        
                                    GestureDetector(
                                      onTap: onLike,
                                      child: _circleBtn(Icons.thumb_up, Colors.purple, Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
        
                  // CENTER ICON (SWIPE + BUTTON BOTH)
                  if (actionIcon != null)
                    Positioned(
                      top: 200,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: 1,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: actionColor.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(actionIcon, color: Colors.white, size: 40),
                        ),
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

  // CIRCLE BUTTON UI
  Widget _circleBtn(IconData icon, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  Future<int> _loadOnlineCount() async {
    await Future.delayed(Duration(seconds: 1));
    return Random().nextInt(200) + 50; // Random online users
  }

  Widget _infoBox(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.pink),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipBox(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (e) => Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            border: Border.all(color: Colors.pink.shade200),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            e,
            style: TextStyle(
                color: Colors.pink.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ),
      )
          .toList(),
    );
  }

}
