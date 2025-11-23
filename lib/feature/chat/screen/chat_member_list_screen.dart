import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatMemberListScreen extends StatefulWidget {
  const ChatMemberListScreen({super.key});

  @override
  State<ChatMemberListScreen> createState() => _ChatMemberListScreenState();
}

class _ChatMemberListScreenState extends State<ChatMemberListScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> members = const [
    {
      'name': 'Aditi Rathod',
      'lastMessage': 'Hey! How are you?',
      'time': '10:15 AM',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      'unread': 2,
      'status': 'seen',
    },
    {
      'name': 'Rohit Sharma',
      'lastMessage': 'Let\'s meet tomorrow!',
      'time': '09:50 AM',
      'image': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200',
      'unread': 0,
      'status': 'delivered',
    },
    {
      'name': 'Priya Verma',
      'lastMessage': 'Sure, sounds good 😊',
      'time': 'Yesterday',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      'unread': 1,
      'status': 'sent',
    },
  ];

  final List<Map<String, String>> statusUsers = const [
    {
      'name': 'Aditi',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    },
    {
      'name': 'Rohit',
      'image': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=100',
    },
    {
      'name': 'Priya',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
    },
    {
      'name': 'Rahul',
      'image': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=100',
    },
    {
      'name': 'Simran',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    },
  ];

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Icon getStatusIcon(String status) {
    switch (status) {
      case 'seen':
        return const Icon(Icons.done_all, size: 16, color: Colors.blue);
      case 'delivered':
        return const Icon(Icons.done_all, size: 16, color: Colors.grey);
      case 'sent':
      default:
        return const Icon(Icons.done, size: 16, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'Chats & Status',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // ===================== STATUS SECTION =====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🔥 Active Stories",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statusUsers.length,
                    itemBuilder: (context, index) {
                      final user = statusUsers[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                double scale = 1 + _animationController.value * 0.1;
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.pink,
                                          Colors.purple
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(user['image']!),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 60,
                              child: Text(
                                user['name']!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ===================== HEADLINE =====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              "💬 Chats",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87),
            ),
          ),

          // ===================== CHAT SECTION =====================
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatScreen()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(member['image']),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    getStatusIcon(member['status']),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        member['lastMessage'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                member['time'],
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              if (member['unread'] > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    '${member['unread']}',
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
