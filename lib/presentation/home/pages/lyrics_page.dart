import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';

class LyricsPage extends StatefulWidget {
  final String title;
  final String artist;
  final String image;

  const LyricsPage({
    super.key,
    required this.title,
    required this.artist,
    required this.image,
  });

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  int _currentLine = 0;
  double _currentTime = 0;
  late Timer _timer;

  // Dummy lyric data (nanti bisa diganti backend)
  final List<Map<String, dynamic>> lyrics = [
    {'time': 0.0, 'text': '( Verse 1 )'},
    {'time': 5.0, 'text': "Sleepin', You're On Your Tippy Toes"},
    {'time': 10.0, 'text': "Creepin' Around Like No One Knows"},
    {'time': 15.0, 'text': "Think You're So Criminal"},
    {'time': 20.0, 'text': "Bruises On Both My Knees For You"},
    {'time': 25.0, 'text': "Don't Say Thank You Or Please"},
    {'time': 30.0, 'text': "I Do What I Want When I'm Wanting To"},
    {'time': 35.0, 'text': "My Soul? So Cynical"},
    {'time': 40.0, 'text': '( Verse 2 )'},
    {'time': 45.0, 'text': "Sleepin', You're On Your Tippy Toes"},
    {'time': 50.0, 'text': "Creepin' Around Like No One Knows"},
    {'time': 55.0, 'text': "Think You're So Criminal"},
    {'time': 60.0, 'text': "Bruises On Both My Knees For You"},
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Simulasi lagu berjalan setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime += 1;
        // update line aktif
        for (int i = 0; i < lyrics.length; i++) {
          if (_currentTime >= lyrics[i]['time']) {
            _currentLine = i;
          }
        }
      });

      // auto scroll ke baris aktif
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _currentLine * 40.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }

      // reset waktu dummy biar looping
      if (_currentTime > 65) {
        _currentTime = 0;
        _currentLine = 0;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final accentColor = AppColors.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // === Background album ===
          Positioned.fill(
            child: Image.asset(
              widget.image,
              fit: BoxFit.cover,
            ),
          ),
          // overlay gelap transparan
          Container(
            color: Colors.black.withOpacity(isDark ? 0.6 : 0.3),
          ),

          // === Main content ===
          SafeArea(
            child: Column(
              children: [
                // === AppBar custom ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert, color: textColor),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // === Scrollable lyrics ===
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: lyrics.length,
                    itemBuilder: (context, index) {
                      final lyric = lyrics[index];
                      final isActive = index == _currentLine;
                      final isTitle = lyric['text'].startsWith('(');

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            if (isActive && !isTitle)
                              Icon(Icons.play_arrow, color: accentColor, size: 16)
                            else if (!isTitle)
                              const SizedBox(width: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                lyric['text'],
                                style: TextStyle(
                                  color: isActive
                                      ? accentColor
                                      : Colors.white.withOpacity(isTitle ? 0.8 : 0.6),
                                  fontWeight: isTitle
                                      ? FontWeight.bold
                                      : (isActive ? FontWeight.w600 : FontWeight.normal),
                                  fontSize: isTitle ? 16 : 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // === Bottom Player (fixed) ===
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF434343)
                        : Colors.white.withOpacity(0.95),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                widget.image,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: textColor,
                                      )),
                                  Text(widget.artist,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: textColor.withOpacity(0.6),
                                      )),
                                ],
                              ),
                            ),
                            Icon(Icons.favorite_border, color: textColor),
                          ],
                        ),
                        Slider(
                          value: _currentTime.clamp(0, 65),
                          max: 65,
                          activeColor: accentColor,
                          inactiveColor: Colors.white24,
                          onChanged: (v) => setState(() => _currentTime = v),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.repeat, color: textColor),
                            Icon(Icons.skip_previous, color: textColor, size: 30),
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: accentColor,
                              child: const Icon(Icons.pause,
                                  color: Colors.white, size: 30),
                            ),
                            Icon(Icons.skip_next, color: textColor, size: 30),
                            Icon(Icons.shuffle, color: textColor),
                          ],
                        ),
                      ],
                    ),
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
