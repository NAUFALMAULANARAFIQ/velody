import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/data/models/songs.dart';

class LyricsPage extends StatefulWidget {
  final Song song;
  final AudioPlayer audioPlayer;
  const LyricsPage({super.key, required this.song, required this.audioPlayer});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  int _currentLine = 0;
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _positionSubscription;

  final List<Map<String, dynamic>> lyrics = [
    {'time': 0.0, 'text': '── Intro ──'},
    {'time': 5.0, 'text': "Sleepin', You're On Your Tippy Toes"},
    {'time': 10.0, 'text': "Creepin' Around Like No One Knows"},
    {'time': 15.0, 'text': "Think You're So Criminal"},
    {'time': 20.0, 'text': "Bruises On Both My Knees For You"},
    {'time': 25.0, 'text': "Don't Say Thank You Or Please"},
    {'time': 30.0, 'text': "I Do What I Want When I'm Wanting To"},
    {'time': 35.0, 'text': "My Soul? So Cynical"},
    {'time': 60.0, 'text': "Bruises On Both My Knees For You"},
  ];

  @override
  void initState() {
    super.initState();
    _positionSubscription = widget.audioPlayer.positionStream.listen((
      position,
    ) {
      final currentSeconds = position.inSeconds.toDouble();

      int newLine = 0;
      for (int i = 0; i < lyrics.length; i++) {
        if (currentSeconds >= lyrics[i]['time']) {
          newLine = i;
        }
      }

      if (newLine != _currentLine) {
        setState(() {
          _currentLine = newLine;
        });
        _scrollToCurrentLine();
      }
    });
  }

  void _scrollToCurrentLine() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _currentLine * 50.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
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
          Positioned.fill(
            child: Image.network(
              widget.song.customCoverUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.black);
              },
            ),
          ),

          Container(color: Colors.black.withOpacity(isDark ? 0.7 : 0.5)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.song.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 50,
                    ),
                    itemCount: lyrics.length,
                    itemBuilder: (context, index) {
                      final lyric = lyrics[index];
                      final isActive = index == _currentLine;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          lyric['text'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isActive
                                ? accentColor
                                : Colors.white.withOpacity(0.6),
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: isActive ? 24 : 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: StreamBuilder<Duration>(
                    stream: widget.audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final pos = snapshot.data ?? Duration.zero;
                      final total =
                          widget.audioPlayer.duration ?? Duration.zero;
                      return LinearProgressIndicator(
                        value:
                            (pos.inSeconds /
                                    (total.inSeconds > 0 ? total.inSeconds : 1))
                                .clamp(0.0, 1.0),
                        color: accentColor,
                        backgroundColor: Colors.white24,
                      );
                    },
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
