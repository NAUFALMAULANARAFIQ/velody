import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_mobile/common/widgets/appbar/app_bar.dart';
import 'package:project_mobile/core/configs/assets/app_images.dart';
import 'package:project_mobile/core/configs/assets/app_vector.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/data/models/songs.dart';
import 'package:project_mobile/presentation/home/pages/music_pages.dart';
import 'package:project_mobile/presentation/home/pages/profile_page.dart';
import 'package:project_mobile/presentation/home/pages/search_page.dart';
import 'package:project_mobile/presentation/home/pages/playlists_page.dart';
import 'package:project_mobile/services/seeder_service.dart';
import 'package:project_mobile/services/song_service.dart';
import 'package:project_mobile/common/widgets/favorite_button/favorite_button.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  final List<String> categories = ['News', 'Video', 'Artists', 'Podcast'];
  late Future<List<Song>> songFuture;

  String _formatDuration(dynamic totalSeconds) {
    if (totalSeconds == null || totalSeconds is! int) {
      return "00:00";
    }

    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  @override
  void initState() {
    super.initState();
    songFuture = SongService.getSongs();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final accentColor = AppColors.primary;

    final pages = [
      _buildHomePage(isDark, textColor, subTextColor, accentColor),
      const SearchPage(),
      const PlaylistPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: pages[_currentIndex],
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.red, // Warna merah biar kelihatan
      //   child: const Icon(Icons.cloud_upload),
      //   onPressed: () async {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("Sedang mengupload lagu...")),
      //     );
          
      //     await SeederService.uploadSongs();
      //     setState(() {
      //        songFuture = SongService.getSongs();
      //     });
          
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("SUKSES! 10 Lagu sudah masuk database!")),
      //     );
      //   },
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: isDark ? const Color(0xFF181818) : Colors.grey[200],
        selectedItemColor: accentColor,
        unselectedItemColor: subTextColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color accentColor,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            BasicAppbar(
              hideBack: true,
              title: SvgPicture.asset(AppVector.logo, height: 40, width: 40),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                height: 188,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(AppVector.homeTopCard),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(AppImages.homeArtist),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: accentColor,
              unselectedLabelColor: subTextColor,
              labelStyle: const TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              indicatorColor: accentColor,
              tabs: categories.map((c) => Tab(text: c)).toList(),
            ),
            _buildSectionTitle('Top Albums', textColor),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: FutureBuilder<List<Song>>(
                future: songFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No albums found"));
                  }
                  final songs = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MusicPage(
                                playlist: songs,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[800],
                            image: DecorationImage(
                              image: NetworkImage(song.customCoverUrl),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                print("Gagal load gambar: ${song.customCoverUrl}");
                              },
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            song.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Satoshi',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            song.artist,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Satoshi',
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: accentColor,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Your Playlists', textColor),
            const SizedBox(height: 12),
            FutureBuilder<List<Song>>(
              future: songFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No playlists found"));
                }
                final songs = snapshot.data!;
                return Column(
                  children: songs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final song = entry.value;
                    return _buildPlaylistTile(
                      song, 
                      isDark,
                      textColor,
                      subTextColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MusicPage(playlist: songs, initialIndex: index),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See all',
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPlaylistTile(
    Song song, 
    bool isDark,
    Color textColor,
    Color subTextColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        color: Colors.transparent, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( 
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      song.customCoverUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                         return Container(
                            width: 40, height: 40,
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                            child: Icon(Icons.music_note, color: subTextColor, size: 20),
                         );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis, 
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                        Text(
                          song.artist,
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis, 
                          style: TextStyle(
                            fontSize: 14,
                            color: subTextColor,
                            fontFamily: 'Satoshi',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  _formatDuration(song.duration), 
                  style: TextStyle(color: subTextColor),
                ),
                const SizedBox(width: 12),
                FavoriteButton(song: song),
              ],
            ),
          ],
        ),
      ),
    );
  }
}