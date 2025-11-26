class Song {
  final int id;
  final String title;
  final String artist;
  final String thumbnail;
  final String fileUrl;
  final String albumImage;
  final int duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.fileUrl,
    required this.albumImage,
    required this.duration,
  });

  String get customCoverUrl {
    String cleanTitle = title
        .toLowerCase()
        .trim()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r"[^\w\-]"), '');
    return "http://10.0.2.2:8000/cover/$cleanTitle.webp";
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    String fixUrl(dynamic url) {
      if (url == null) return 'https://via.placeholder.com/150';
      if (url is! String) return 'https://via.placeholder.com/150';
      if (url.contains('127.0.0.1') || url.contains('localhost')) {
        return url.replaceAll(RegExp(r'127\.0\.0\.1|localhost'), '10.0.2.2');
      }
      return url;
    }

    String parseArtist(dynamic artistField) {
      if (artistField == null) return 'Unknown Artist';
      if (artistField is String) return artistField;
      if (artistField is Map<String, dynamic>) {
        return artistField['name'] ?? 'Unknown Artist';
      }
      return 'Unknown Artist';
    }

    int parseDuration(dynamic value) {
      if (value == null) return 0; 
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value) ?? 0; 
      }
      if (value is double) return value.toInt(); 
      return 0;
    }

    String rawTitle = json['title'] ?? 'Unknown Title';

    return Song(
      id: json['id_songs'] ?? 0,
      title: rawTitle,
      artist: parseArtist(json['artist']),
      thumbnail: fixUrl(json['cover_image'] ?? json['thumbnail']),
      fileUrl: fixUrl(json['file_url'] ?? json['audio_url']),
      albumImage: "", 
      duration: parseDuration(json['duration']), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'cover_image': thumbnail,
      'file_url': fileUrl,
      'duration': duration,
    };
  }
}