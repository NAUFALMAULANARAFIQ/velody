import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // <-- Pakai ini
import 'package:project_mobile/data/models/songs.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/presentation/home/pages/lyrics_page.dart';
import 'package:project_mobile/common/widgets/favorite_button/favorite_button.dart';
import 'package:project_mobile/common/widgets/playlist/add_to_playlist_sheet.dart';

class MusicPage extends StatefulWidget {
  final List<Song> playlist;
  final int initialIndex;

  const MusicPage({super.key, required this.playlist, this.initialIndex = 0});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  late AudioPlayer _audioPlayer; // Pakai Audioplayers
  late int currentIndex;
  
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  // Getter lagu aktif
  Song get currentSong => widget.playlist[currentIndex];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // 1. Listen Durasi Lagu (Total Waktu)
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() => totalDuration = newDuration);
      }
    });

    // 2. Listen Posisi Lagu (Jalannya Slider)
    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() => currentPosition = newPosition);
      }
    });

    // 3. Listen Status (Play/Pause/Stop)
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    // 4. Listen Kalau Lagu Selesai (Auto Next)
    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });

    // Mulai putar lagu pertama
    _playSong(currentSong);
  }

  Future<void> _playSong(Song song) async {
    try {
      // Stop dulu biar aman
      await _audioPlayer.stop();
      
      // Play dari URL (UrlSource khusus Audioplayers)
      // song.fileUrl berasal dari Model yang sudah kita fix tadi
      await _audioPlayer.play(UrlSource(song.fileUrl)); 
      
      if (mounted) {
        setState(() {
          isPlaying = true;
        });
      }
    } catch (e) {
      print("Error playing song beb: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memutar lagu: ${e.toString()}")),
      );
    }
  }

  void _nextSong() {
    if (currentIndex < widget.playlist.length - 1) {
      setState(() => currentIndex++);
      _playSong(currentSong);
    }
  }

  void _previousSong() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _playSong(currentSong);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[600];
    final accentColor = AppColors.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Now playing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.playlist_add, color: textColor),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AddToPlaylistSheet(
                          // WARNING: Pastikan AddToPlaylistSheet kamu menerima String ya, 
                          // karena song.id sekarang tipenya String (dari Firebase).
                          songId: currentSong.id, 
                        )
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- ALBUM ART ---
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 360,
                  width: double.infinity,
                  child: Image.network(
                    currentSong.customCoverUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 360,
                        color: Colors.grey[900],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 360, color: Colors.grey[800],
                        child: const Icon(Icons.broken_image, size: 80, color: Colors.white24),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
              
              // --- TITLE & ARTIST ---
              Text(
                currentSong.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                textAlign: TextAlign.center,
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                currentSong.artist,
                style: TextStyle(fontSize: 16, color: subTextColor),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // --- LIKE BUTTON ---
              FavoriteButton(song: currentSong, size: 30),

              // --- SLIDER ---
              Column(
                children: [
                  Slider(
                    value: currentPosition.inSeconds.toDouble().clamp(0.0, totalDuration.inSeconds.toDouble()),
                    max: totalDuration.inSeconds.toDouble() > 0 ? totalDuration.inSeconds.toDouble() : 1,
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                    activeColor: accentColor,
                    inactiveColor: isDark ? Colors.white10 : Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDuration(currentPosition), style: TextStyle(color: subTextColor)),
                      Text(formatDuration(totalDuration), style: TextStyle(color: subTextColor)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- MUSIC CONTROLS ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.repeat, color: subTextColor)),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _previousSong,
                    icon: Icon(Icons.skip_previous_rounded, size: 36, color: textColor),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      iconSize: 36,
                      onPressed: () {
                        if (isPlaying) {
                          _audioPlayer.pause();
                        } else {
                          _audioPlayer.resume(); // Di audioplayers pakai resume() kalau sudah di-load
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _nextSong,
                    icon: Icon(Icons.skip_next_rounded, size: 36, color: textColor),
                  ),
                  const SizedBox(width: 10),
                  IconButton(onPressed: () {}, icon: Icon(Icons.shuffle, color: subTextColor)),
                ],
              ),
              const SizedBox(height: 16),

              // --- LYRICS BUTTON ---
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LyricsPage(
                        song: currentSong,
                        // Kalau LyricsPage kamu minta 'just_audio.AudioPlayer', 
                        // kamu mungkin perlu edit LyricsPage juga.
                        // Tapi kalau cuma kirim data lagu, ini aman.
                        audioPlayer: _audioPlayer,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.keyboard_arrow_up_rounded, color: textColor),
                label: Text('Lyrics', style: TextStyle(fontSize: 16, color: textColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}