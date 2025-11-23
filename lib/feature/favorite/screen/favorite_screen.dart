import 'package:dating_app/feature/home/screen/view_profile_details_screen.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> favorites = [
    {
      'name': 'Aditi Rathod',
      'age': 25,
      'location': 'Indore',
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
      'isFavorite': true
    },
    {
      'name': 'Priya Sharma',
      'age': 23,
      'location': 'Mumbai',
      'image': 'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=500',
      'isFavorite': true
    },
    {
      'name': 'Neha Gupta',
      'age': 27,
      'location': 'Delhi',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
      'isFavorite': true
    },
    {
      'name': 'Aditi Rathod',
      'age': 25,
      'location': 'Indore',
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
      'isFavorite': true
    },
    {
      'name': 'Priya Sharma',
      'age': 23,
      'location': 'Mumbai',
      'image': 'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=500',
      'isFavorite': true
    },
    {
      'name': 'Neha Gupta',
      'age': 27,
      'location': 'Delhi',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
      'isFavorite': true
    },
  ];

  void toggleFavorite(int index) {
    setState(() {
      favorites[index]['isFavorite'] = !favorites[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your Loved Ones 💖',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade400, Colors.pink.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Notification Icon
                      _appBarIcon(Icons.notifications, () {}),
                      const SizedBox(width: 12),
                      // Gift Icon
                      _appBarIcon(Icons.card_giftcard, () {}),
                      const SizedBox(width: 12),
                      // Filter/Search Icon
                      _appBarIcon(Icons.filter_alt, () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
          favorites.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
          )
              : SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final profile = favorites[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfileDetailScreen(),));
                    },
                    child: Stack(
                      children: [
                        // Profile Card
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(profile['image']),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        // Name, Age & Location
                        Positioned(
                          left: 12,
                          bottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    profile['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, color: Colors.blue, size: 16),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${profile['age']} yrs • ${profile['location']}',
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        // Favorite button
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => toggleFavorite(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                profile['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                color: Colors.pink,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: favorites.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.pink, size: 22),
      ),
    );
  }
}
