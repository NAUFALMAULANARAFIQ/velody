import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_mobile/common/widgets/appbar/app_bar.dart';
import 'package:project_mobile/core/configs/assets/app_images.dart';
import 'package:project_mobile/core/configs/assets/app_vector.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/presentation/home/pages/music_pages.dart';
import 'package:project_mobile/presentation/home/pages/profile_page.dart';
import 'package:project_mobile/presentation/home/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<String> categories = ['News', 'Video', 'Artists', 'Podcast'];

  final List<Map<String, String>> albums = [
    {'title': 'Bad Guy', 'artist': 'Billie Elish', 'image': AppImages.album1},
    {'title': 'Scorpion', 'artist': 'Drake', 'image': AppImages.album2},
    {'title': 'Bird Of Feather', 'artist': 'Billie Elish', 'image': AppImages.album3},
  ];

  final List<Map<String, String>> playlists = [
    {'title': 'Chill Vibes', 'desc': 'Relax and focus', 'image': AppImages.album1},
    {'title': 'Workout Mix', 'desc': 'Boost your energy', 'image': AppImages.album2},
    {'title': 'Focus Beats', 'desc': 'Stay productive', 'image': AppImages.album3},
  ];

  @override
  void initState() {
    super.initState();
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
      Center(child: Text("Library Page (Coming Soon)", style: TextStyle(color: textColor))),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: pages[_currentIndex],

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
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // ========================= HOME CONTENT ==========================
  Widget _buildHomePage(bool isDark, Color textColor, Color subTextColor, Color accentColor) {
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(album['image']!),
                        fit: BoxFit.cover,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(album['title']!,
                                        style: const TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                    Text(album['artist']!,
                                        style: const TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontSize: 12,
                                          color: Colors.white70,
                                        )),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MusicPage(
                                        title: album['title']!,
                                        artist: album['artist']!,
                                        image: album['image']!,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentColor,
                                  ),
                                  child: const Icon(Icons.play_arrow,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Your Playlists', textColor),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildPlaylistTile('As It Was', 'Harry Styles', '5:33', isDark, textColor, subTextColor),
                _buildPlaylistTile('God Did', 'DJ Khaled', '3:43', isDark, textColor, subTextColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========================== HELPERS ==========================

  Widget _buildSectionTitle(String title, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            )),
        TextButton(
          onPressed: () {},
          child: const Text('See all',
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 14,
                color: AppColors.primary,
              )),
        ),
      ],
    );
  }

  Widget _buildPlaylistTile(String title, String artist, String duration, bool isDark, Color textColor, Color subTextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Satoshi',
                      )),
                  Text(artist,
                      style: TextStyle(
                        fontSize: 14,
                        color: subTextColor,
                        fontFamily: 'Satoshi',
                      )),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(duration, style: TextStyle(color: subTextColor)),
              const SizedBox(width: 12),
              Icon(Icons.favorite_border, color: subTextColor),
            ],
          ),
        ],
      ),
    );
  }
}
