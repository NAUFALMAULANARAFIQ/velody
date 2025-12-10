import 'package:flutter/material.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/data/models/songs.dart';
import 'package:project_mobile/presentation/home/pages/music_pages.dart';
import 'package:project_mobile/services/song_service.dart';
import 'package:project_mobile/services/history_service.dart'; // Pastikan import ini ada

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  List<Song> _historySongs = [];
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Ambil Data Lagu & History Sekaligus
  Future<void> _fetchData() async {
    try {
      final results = await Future.wait([
        SongService.getSongs(),       // Index 0
        HistoryService.getHistory(),  // Index 1
      ]);

      if (mounted) {
        setState(() {
          _allSongs = results[0];
          _historySongs = results[1];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching search data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Refresh History setelah nge-klik lagu
  Future<void> _refreshHistory() async {
    final history = await HistoryService.getHistory();
    if (mounted) {
      setState(() {
        _historySongs = history;
      });
    }
  }

  // Logic Filter Pencarian (Client Side)
  void _runFilter(String enteredKeyword) {
    List<Song> results = [];
    if (enteredKeyword.isEmpty) {
      results = [];
    } else {
      results = _allSongs
          .where((song) =>
              song.title.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              song.artist.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredSongs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0A0A0A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[700];
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.grey[200];

    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_searchController.text.isEmpty) {
      // KONDISI 1: Belum ngetik apa-apa (Tampilkan History)
      if (_historySongs.isEmpty) {
        bodyContent = _emptyState(textColor);
      } else {
        bodyContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Text(
                "Recent Searches",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _historySongs.length,
                itemBuilder: (context, index) {
                  final song = _historySongs[index];
                  return _musicCard(song, textColor, cardColor, isDark, isHistory: true);
                },
              ),
            ),
          ],
        );
      }
    } else {
      // KONDISI 2: Sedang mencari (Tampilkan Hasil Filter)
      if (_filteredSongs.isEmpty) {
        bodyContent = _notFound(textColor);
      } else {
        bodyContent = ListView.builder(
          itemCount: _filteredSongs.length,
          itemBuilder: (context, index) {
            final song = _filteredSongs[index];
            return _musicCard(song, textColor, cardColor, isDark);
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Search", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _runFilter,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search songs or artists...',
                  hintStyle: TextStyle(color: hintColor),
                  prefixIcon: Icon(Icons.search, color: textColor),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: textColor),
                          onPressed: () {
                            _searchController.clear();
                            _runFilter('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Content (History / Result / Empty)
            Expanded(child: bodyContent),
          ],
        ),
      ),
    );
  }

  Widget _musicCard(Song song, Color textColor, Color? cardColor, bool isDark, {bool isHistory = false}) {
    return GestureDetector(
      onTap: () async {
        // 1. Simpan ke History Firebase
        await HistoryService.addHistory(song.id);
        
        // 2. Refresh tampilan history di background
        _refreshHistory(); 

        // 3. Pindah ke Halaman Putar Musik
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicPage(
                playlist: [song], // Putar lagu ini saja
                initialIndex: 0,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song.customCoverUrl,
              width: 50, height: 50, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50, height: 50, color: Colors.grey[800],
                  child: Icon(Icons.music_note, color: textColor),
                );
              },
            ),
          ),
          title: Text(
            song.title,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            song.artist,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
          // Icon beda kalau history (Jam) vs hasil search (Play)
          trailing: isHistory 
            ? Icon(Icons.history, color: AppColors.primary) 
            : Icon(Icons.play_circle_fill, color: AppColors.primary, size: 32),
        ),
      ),
    );
  }

  Widget _emptyState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, color: textColor.withOpacity(0.3), size: 80),
          const SizedBox(height: 15),
          Text(
            'Find your favorite songs',
            style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _notFound(Color textColor) {
    return Center(
      child: Text(
        'No results found',
        style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 16),
      ),
    );
  }
}