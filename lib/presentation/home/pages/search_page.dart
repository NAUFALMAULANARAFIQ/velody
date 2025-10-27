import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_mobile/presentation/choose_mode/bloc/theme_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  List<Map<String, String>> searchResults = [];

  final List<Map<String, String>> allSongs = [
    {'title': 'Lose Yourself', 'artist': 'Eminem'},
    {'title': 'Blinding Lights', 'artist': 'The Weeknd'},
    {'title': 'Shape of You', 'artist': 'Ed Sheeran'},
    {'title': 'Bad Guy', 'artist': 'Billie Eilish'},
    {'title': 'Stay', 'artist': 'The Kid LAROI, Justin Bieber'},
    {'title': 'Someone Like You', 'artist': 'Adele'},
  ];

  void searchSong(String input) {
    setState(() {
      query = input;
      searchResults = allSongs
          .where((song) =>
              song['title']!.toLowerCase().contains(input.toLowerCase()) ||
              song['artist']!.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;

    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[700];
    final containerColor = isDark ? Colors.grey[900] : Colors.grey[200];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search Field
            Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: searchSong,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search songs, artists...',
                  hintStyle: TextStyle(color: hintColor),
                  prefixIcon: Icon(Icons.search, color: textColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 📄 Search Results
            Expanded(
              child: query.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note,
                              color: textColor.withOpacity(0.5), size: 64),
                          const SizedBox(height: 12),
                          Text(
                            'Search your favorite songs',
                            style: TextStyle(color: textColor.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    )
                  : searchResults.isEmpty
                      ? Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(color: textColor.withOpacity(0.5)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final song = searchResults[index];
                            return ListTile(
                              leading: Icon(Icons.music_note, color: textColor),
                              title: Text(
                                song['title']!,
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                song['artist']!,
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                ),
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Playing ${song['title']}...'),
                                  ),
                                );
                              },
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
