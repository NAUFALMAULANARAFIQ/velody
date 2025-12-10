import 'package:flutter/material.dart';
import 'package:project_mobile/core/configs/themes/app_colors.dart';
import 'package:project_mobile/data/models/playlist.dart';
import 'package:project_mobile/services/playlist_service.dart';

class AddToPlaylistSheet extends StatefulWidget {
  final String songId;

  const AddToPlaylistSheet({super.key, required this.songId});

  @override
  State<AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  late Future<List<PlaylistModel>> _playlistsFuture;

  @override
  void initState() {
    super.initState();
    _playlistsFuture = PlaylistService.getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add to Playlist",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<PlaylistModel>>(
              future: _playlistsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No playlists found", style: TextStyle(color: Colors.grey)));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final playlist = snapshot.data![index];
                    return ListTile(
                      leading: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.music_note, color: Colors.white),
                      ),
                      title: Text(playlist.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text("${playlist.songsCount} songs", style: const TextStyle(color: Colors.grey)),
                      onTap: () async {
                        bool success = await PlaylistService.addSongToPlaylist(playlist.id, widget.songId);
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? "Added to ${playlist.name}" : "Failed to add (Maybe duplicate?)"),
                              backgroundColor: success ? AppColors.primary : Colors.red,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}