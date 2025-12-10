import 'package:flutter/material.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/data/models/songs.dart';
import 'package:project_mobile/presentation/home/pages/music_pages.dart';
import 'package:project_mobile/presentation/auth/pages/signin.dart';
import 'package:project_mobile/services/user_service.dart';
import 'package:project_mobile/services/favorite_service.dart';
import 'package:project_mobile/services/auth_service.dart'; 
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  List<Song> _favoriteSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Ambil Profil & Favorit secara bersamaan
      final results = await Future.wait([
        UserService.getUserProfile(),
        FavoriteService.getFavorites(),
      ]);

      if (mounted) {
        setState(() {
          _userData = results[0] as Map<String, dynamic>?;
          // Pastikan hasil favorites di-cast dengan aman
          _favoriteSongs = (results[1] as List).cast<Song>(); 
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading profile: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- LOGIC LOGOUT TERBARU (FIREBASE) ---
  Future<void> _logout() async {
    try {
      print("🚀 1. Mulai ambil Data Profil...");
      
      // Kita pecah biar ketahuan macet dimana
      var userProfile = await UserService.getUserProfile();
      print("✅ 2. Profil didapat: $userProfile");

      print("🚀 3. Mulai ambil Favorites...");
      var favorites = await FavoriteService.getFavorites();
      print("✅ 4. Favorites didapat: ${favorites.length} lagu");

      if (mounted) {
        setState(() {
          _userData = userProfile;
          _favoriteSongs = favorites;
          _isLoading = false;
        });
        print("🎉 5. UI Diupdate!");
      }
    } catch (e) {
      print("❌ ERROR DI PROFILE: $e");
      // Kalau error, matikan loading biar gak muter selamanya
      if (mounted) setState(() => _isLoading = false);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    // 1. Panggil Logout dari AuthService Firebase
    await AuthService().signOut();

    if (mounted) {
      Navigator.pop(context); // Tutup loading dialog
      
      // 2. Pindah ke Halaman Login & Hapus semua history halaman sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SigninPages()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    // Ambil inisial nama (Misal "Naufal" -> "N")
    String initialName = "?";
    if (_userData != null && _userData!['username'] != null) {
       String name = _userData!['username'];
       if (name.isNotEmpty) {
         initialName = name[0].toUpperCase();
       }
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        // --- HEADER ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Navigator.canPop(context)
                                ? IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: textColor,
                                      size: 20,
                                    ),
                                  )
                                : const SizedBox(width: 40, height: 40),

                            Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),

                            // --- MENU LOGOUT ---
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: subTextColor),
                              color: isDark ? const Color(0xFF333333) : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onSelected: (value) {
                                if (value == 'logout') {
                                  _logout();
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem<String>(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout, color: Colors.red, size: 20),
                                      SizedBox(width: 10),
                                      Text(
                                        'Log Out',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- AVATAR ---
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[800],
                          child: Text(
                            initialName,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // --- EMAIL ---
                        Text(
                          _userData?['email'] ?? 'No Email',
                          style: TextStyle(color: subTextColor, fontSize: 14),
                        ),
                        const SizedBox(height: 6),

                        // --- USERNAME ---
                        Text(
                          _userData?['username'] ?? 'Guest',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- STATISTIK ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStat(
                              "Favorites",
                              _favoriteSongs.length.toString(),
                              textColor,
                              subTextColor,
                            ),
                            const SizedBox(width: 40),
                            _buildStat(
                              "Following",
                              "0", // Fitur following belum kita buat, jadi 0 dulu
                              textColor,
                              subTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- LIST FAVORITE HEADER ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'FAVORITE SONGS',
                        style: TextStyle(
                          color: subTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- LIST FAVORITE ITEMS ---
                  Expanded(
                    child: _favoriteSongs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 50,
                                  color: subTextColor.withOpacity(0.3),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "No favorites yet",
                                  style: TextStyle(color: subTextColor),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _favoriteSongs.length,
                            itemBuilder: (context, index) {
                              final song = _favoriteSongs[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MusicPage(
                                        playlist: _favoriteSongs,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          song.customCoverUrl,
                                          width: 55,
                                          height: 55,
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, stack) =>
                                              Container(
                                            width: 55,
                                            height: 55,
                                            color: Colors.grey[800],
                                            child: const Icon(
                                              Icons.music_note,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              song.artist,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: subTextColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
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

  Widget _buildStat(
    String label,
    String count,
    Color textColor,
    Color subTextColor,
  ) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
        Text(label, style: TextStyle(color: subTextColor, fontSize: 14)),
      ],
    );
  }
}