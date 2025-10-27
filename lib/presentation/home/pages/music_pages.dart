import 'package:flutter/material.dart';
import 'package:project_mobile/core/configs/assets/app_images.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/presentation/home/pages/lyrics_page.dart';

class MusicPage extends StatelessWidget {
  final String title;
  final String artist;
  final String image;

  const MusicPage({
    super.key,
    required this.title,
    required this.artist,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // Deteksi mode tema
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[600];
    final accentColor = AppColors.primary; // Hijau Spotify-like

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: textColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Now playing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: textColor),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Album Art ---
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  image,
                  height: 360,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // --- Song Title & Artist ---
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                artist,
                style: TextStyle(
                  fontSize: 16,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 12),

              // --- Like Button ---
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border, color: subTextColor),
              ),
              const SizedBox(height: 12),

              // --- Slider ---
              Column(
                children: [
                  Slider(
                    value: 2.25,
                    min: 0,
                    max: 4.02,
                    divisions: 100,
                    onChanged: (value) {},
                    activeColor: accentColor,
                    inactiveColor: isDark ? Colors.white10 : Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('2:25', style: TextStyle(color: subTextColor)),
                      Text('4:02', style: TextStyle(color: subTextColor)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Control Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.repeat, color: subTextColor),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.skip_previous_rounded, size: 36, color: textColor),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white),
                      iconSize: 36,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.skip_next_rounded, size: 36, color: textColor),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.shuffle, color: subTextColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Lyrics Button ---
              TextButton.icon(
                onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LyricsPage(
                          title: title,
                          artist: artist,
                          image: AppImages.album1, // bebas sementara
                        ),
                      ),
                    );

                },
                icon: Icon(Icons.keyboard_arrow_up_rounded, color: textColor),
                label: Text(
                  'Lyrics',
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
