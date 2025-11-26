class PlaylistModel {
  final int id;
  final String name;
  final int songsCount;

  PlaylistModel({
    required this.id,
    required this.name,
    this.songsCount = 0,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id_playlists'] ?? 0,
      name: json['name'] ?? 'Untitled Playlist',
      songsCount: json['songs_count'] ?? 0,
    );
  }
}