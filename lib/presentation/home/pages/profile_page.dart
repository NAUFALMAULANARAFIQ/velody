import 'package:flutter/material.dart';
import 'package:project_mobile/core/configs/assets/app_images.dart';
import 'package:project_mobile/presentation/home/pages/home.dart';
import 'package:project_mobile/presentation/home/pages/search_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3; // posisi aktif: Profile

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final accentColor = const Color(0xFF3DDC84); // Hijau Spotify-like

    // Dummy playlist data
    final List<Map<String, String>> playlists = [
      {'title': 'Dont Smile At Me', 'artist': 'Billie Eilish', 'image': AppImages.album1},
      {'title': 'As It Was', 'artist': 'Harry Styles', 'image': AppImages.album2},
      {'title': 'Super Freaky Girl', 'artist': 'Nicki Minaj', 'image': AppImages.album3},
      {'title': 'Bad Habit', 'artist': 'Steve Lacy', 'image': AppImages.album4},
      {'title': 'Planet Her', 'artist': 'Doja Cat', 'image': AppImages.album5},
      {'title': 'Sweetest Pie', 'artist': 'Megan Thee Stallion', 'image': AppImages.album6},
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER PROFILE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new_rounded,
                            color: textColor, size: 20),
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert, color: subTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Profile photo
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage('assets/images/profile.jpeg'),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),

                  // Email
                  Text(
                    'soroushnorozyui@gmail.com',
                    style: TextStyle(color: subTextColor, fontSize: 14),
                  ),
                  const SizedBox(height: 4),

                  // Username
                  Text(
                    'Soroushnrz',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Followers & Following
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('778',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textColor)),
                          Text('Followers',
                              style:
                                  TextStyle(color: subTextColor, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Column(
                        children: [
                          Text('243',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textColor)),
                          Text('Following',
                              style:
                                  TextStyle(color: subTextColor, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // --- PLAYLIST TITLE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PUBLIC PLAYLISTS',
                  style: TextStyle(
                    color: subTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // --- PLAYLIST LIST ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            playlist['image']!,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey[400],
                              child: const Icon(Icons.music_note, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlist['title']!,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                playlist['artist']!,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('5:33', style: TextStyle(color: subTextColor)),
                        const SizedBox(width: 10),
                        Icon(Icons.more_vert, color: subTextColor),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
