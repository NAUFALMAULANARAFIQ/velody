import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // <-- Ganti ke ini
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/data/models/songs.dart';

class LyricsPage extends StatefulWidget {
  final Song song;
  final AudioPlayer audioPlayer; // Ini sekarang tipe dari package audioplayers

  const LyricsPage({super.key, required this.song, required this.audioPlayer});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  int _currentLine = 0;
  final ScrollController _scrollController = ScrollController();
  
  // Subscription untuk memantau lagu
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  // Variabel lokal untuk progress bar
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Contoh lirik (Nanti bisa diambil dari Firebase kalau mau dikembangkan)
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
    _setupAudioListeners();
  }

  void _setupAudioListeners() async {
    // 1. Ambil durasi total saat ini (karena mungkin lagu sudah jalan)
    final duration = await widget.audioPlayer.getDuration();
    if (mounted && duration != null) {
      setState(() => _totalDuration = duration);
    }

    // 2. Listen perubahan Durasi (jaga-jaga loading baru selesai)
    _durationSubscription = widget.audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _totalDuration = d);
    });

    // 3. Listen Posisi Lagu (Detik berjalan)
    _positionSubscription = widget.audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _currentPosition = position;
      });

      // --- LOGIKA SINKRONISASI LIRIK ---
      final currentSeconds = position.inSeconds.toDouble();
      int newLine = 0;
      
      // Cari baris lirik yang pas dengan detik sekarang
      for (int i = 0; i < lyrics.length; i++) {
        if (currentSeconds >= lyrics[i]['time']) {
          newLine = i;
        }
      }

      // Kalau baris berubah, scroll otomatis
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
      // Scroll ke posisi index * tinggi baris (kira-kira 60 pixel)
      // Dikurangi sedikit biar liriknya ada di tengah, bukan paling atas
      double offset = (_currentLine * 60.0) - 100;
      if (offset < 0) offset = 0;

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final accentColor = AppColors.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // --- BACKGROUND IMAGE ---
          Positioned.fill(
            child: Image.network(
              widget.song.customCoverUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.black);
              },
            ),
          ),

          // --- OVERLAY HITAM ---
          Container(color: Colors.black.withOpacity(isDark ? 0.8 : 0.6)),
          
          SafeArea(
            child: Column(
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.song.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.song.artist,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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

                // --- LYRICS LIST ---
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
                    itemCount: lyrics.length,
                    itemBuilder: (context, index) {
                      final lyric = lyrics[index];
                      final isActive = index == _currentLine;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          lyric['text'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isActive ? accentColor : Colors.white.withOpacity(0.5),
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                            fontSize: isActive ? 26 : 18,
                            height: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // --- PROGRESS BAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: LinearProgressIndicator(
                    value: (_totalDuration.inSeconds > 0)
                        ? (_currentPosition.inSeconds / _totalDuration.inSeconds).clamp(0.0, 1.0)
                        : 0.0,
                    color: accentColor,
                    backgroundColor: Colors.white24,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
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