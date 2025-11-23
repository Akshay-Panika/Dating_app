import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {'text': 'Hey! How are you?', 'isMe': false, 'time': DateTime.now().subtract(Duration(minutes: 5)), 'seen': true},
    {'text': 'I am good! What about you?', 'isMe': true, 'time': DateTime.now().subtract(Duration(minutes: 4)), 'seen': true},
    {'text': 'Doing great, thanks 😊', 'isMe': false, 'time': DateTime.now().subtract(Duration(minutes: 3)), 'seen': false},
    {'text': 'Wanna grab coffee sometime? Maybe we can go to that new cafe near the park. What do you think?', 'isMe': true, 'time': DateTime.now().subtract(Duration(minutes: 1)), 'seen': false},
  ];

  bool isTyping = false;

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'text': _controller.text.trim(),
        'isMe': true,
        'time': DateTime.now(),
        'seen': false,
      });
      _controller.clear();
      isTyping = false;
    });

    Future.delayed(
      const Duration(milliseconds: 100),
          () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
            ),
            const SizedBox(width: 10),
            const Text(
              'Aditi Rathod',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call, color: Colors.white,)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white,)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isTyping) {
                    return _buildTypingIndicator();
                  }
        
                  final msg = messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: msg['isMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!msg['isMe'])
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
                            ),
                          ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: msg['isMe']
                                  ? LinearGradient(colors: [Colors.pink.shade400, Colors.pink.shade200])
                                  : null,
                              color: msg['isMe'] ? null : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(msg['isMe'] ? 18 : 0),
                                bottomRight: Radius.circular(msg['isMe'] ? 0 : 18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  msg['text'],
                                  style: TextStyle(
                                    color: msg['isMe'] ? Colors.white : Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _formatTime(msg['time']),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    if (msg['isMe'])
                                      Icon(
                                        msg['seen'] ? Icons.done_all : Icons.done,
                                        size: 14,
                                        color: msg['seen'] ? Colors.blue : Colors.grey,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (msg['isMe'])
                          const SizedBox(width: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
        
            // Typing Indicator
            if (isTyping) _buildTypingIndicator(),
        
            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Add / Media / Emoji Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.pink),
                      onPressed: () {
                        // TODO: Add media picker / emoji picker
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Text Field
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 40,
                        maxHeight: 120,
                      ),
                      child: Scrollbar(
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          minLines: 1,
                          onChanged: (val) {
                            setState(() {
                              isTyping = val.isNotEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isTyping ? Colors.pink : Colors.grey[400],
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (isTyping)
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: isTyping ? _sendMessage : null,
                    ),
                  ),
                ],
              ),
            )
        
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Dot(), const SizedBox(width: 4),
                const Dot(), const SizedBox(width: 4),
                const Dot(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
    );
  }
}
