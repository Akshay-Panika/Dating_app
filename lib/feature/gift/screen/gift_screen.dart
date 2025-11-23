import 'package:flutter/material.dart';
import 'dart:math';

class GiftScreen extends StatefulWidget {
  const GiftScreen({super.key});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Random random = Random();

  int userCoins = 500;

  final List<String> filters = ['All', 'Jewelry', 'Flowers', 'Luxury'];
  String selectedFilter = 'All';

  final Map<String, List<Map<String, dynamic>>> giftCategories = {
    'Romantic': [
      {
        'name': 'Rose Bouquet',
        'type': 'Flowers',
        'image': 'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=500',
        'price': 100
      },
      {
        'name': 'Diamond Ring',
        'type': 'Jewelry',
        'image': 'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?w=500',
        'price': 500
      },
      {
        'name': 'Chocolate Box',
        'type': 'Luxury',
        'image': 'https://images.unsplash.com/photo-1606813908618-f4d5b6eec5aa?w=500',
        'price': 150
      },
    ],
    'Fun': [
      {
        'name': 'Teddy Bear',
        'type': 'Luxury',
        'image': 'https://images.unsplash.com/photo-1606220794230-c3c02aab8a44?w=500',
        'price': 250
      },
      {
        'name': 'Birthday Cake',
        'type': 'Luxury',
        'image': 'https://images.unsplash.com/photo-1563805042-7684d5f02a89?w=500',
        'price': 200
      },
      {
        'name': 'Balloon Set',
        'type': 'Luxury',
        'image': 'https://images.unsplash.com/photo-1524066921091-ec6e4b3c18a7?w=500',
        'price': 50
      },
    ],
    'Luxury': [
      {
        'name': 'Perfume',
        'type': 'Luxury',
        'image': 'https://images.unsplash.com/photo-1591297097860-f68aa2ad8282?w=500',
        'price': 5000
      },
      {
        'name': 'Gold Watch',
        'type': 'Luxury',
        'image': 'https://images.unsplash.com/photo-1581291519195-ef11498d1cf9?w=500',
        'price': 12000
      },
      {
        'name': 'Necklace',
        'type': 'Jewelry',
        'image': 'https://images.unsplash.com/photo-1616440618232-2b5f9c3084f0?w=500',
        'price': 15000
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: giftCategories.keys.length, vsync: this);
    giftCategories.forEach((key, list) => list.shuffle(random));
  }

  List<Map<String, dynamic>> _filterGifts(String category) {
    final gifts = giftCategories[category]!;
    if (selectedFilter == 'All') return gifts;
    return gifts.where((g) => g['type'] == selectedFilter).toList();
  }

  void _buyGift(Map<String, dynamic> gift) {
    int price = (gift['price'] as num).toInt();
    if (userCoins < price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coins not sufficient! Recharge your wallet')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send ${gift['name']}?'),
        content: Text('This gift costs ₹$price. Your balance: ₹$userCoins'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            onPressed: () {
              setState(() {
                userCoins -= price;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('You sent ${gift['name']} 💖')),
              );
            },
            child: const Text('Send', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff48fb1), Color(0xfff9f0f7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Send a Gift',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, color: Colors.white),
                          const SizedBox(width: 6),
                          Text('₹$userCoins',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),

                // TabBar
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: giftCategories.keys.map((cat) => Tab(text: cat)).toList(),
                ),

                // Filters
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      final isSelected = filter == selectedFilter;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white),
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => selectedFilter = filter),
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected ? Colors.pink : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Gifts Grid
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: giftCategories.keys.map((category) {
                      final gifts = _filterGifts(category);
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          itemCount: gifts.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final gift = gifts[index];
                            return GestureDetector(
                              onTap: () => _buyGift(gift),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                        child: Image.network(
                                          gift['image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(gift['name'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('₹${gift['price']}',
                                        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => _buyGift(gift),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.pink,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          child: const Text('Buy',
                                              style: TextStyle(fontSize: 14, color: Colors.white)),
                                        ),
                                        OutlinedButton(
                                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Shared ${gift['name']}'))),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          child: const Icon(Icons.share, size: 18, color: Colors.pink),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
