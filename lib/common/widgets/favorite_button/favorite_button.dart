import 'package:flutter/material.dart';
import 'package:project_mobile/data/models/songs.dart';
import 'package:project_mobile/services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final Song song;
  final double size;

  const FavoriteButton({
    super.key,
    required this.song,
    this.size = 24,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false; // Default state (Nanti idealnya ambil dari DB juga)

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.size,
      onPressed: () async {
        // 1. Ubah UI duluan biar responsif (Optimistic UI)
        setState(() {
          isFavorite = !isFavorite;
        });

        // 2. Kirim request ke Server di background
        // Asumsi: song.id adalah tipe dynamic/int dari JSON Laravel 'id'
        // Kita perlu pastikan song model punya field 'id'
        bool success = await FavoriteService.toggleFavorite(widget.song.id);
        
        // (Optional) Kalau request gagal, balikin warnanya
        // if (!success) setState(() => isFavorite = !isFavorite);
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey, // Merah kalau fav
      ),
    );
  }
}