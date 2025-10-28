# 🎵 Velody — Aplikasi Pemutar Musik Mellow

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Stable-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

📌 **Deskripsi Singkat**  
Velody adalah aplikasi pemutar musik berbasis **Flutter** yang dirancang untuk menghadirkan pengalaman mendengarkan musik yang lembut, tenang, dan elegan.  
Aplikasi ini mengusung konsep **musik mellow** dengan tampilan **minimalis modern**, serta mendukung mode **Light** dan **Dark** untuk menyesuaikan preferensi pengguna.  

Velody dibuat sebagai proyek **UTS Pemrograman Mobile** dengan tujuan untuk melatih pengembangan aplikasi mobile yang fokus pada kenyamanan pengguna dan estetika antarmuka.

---

🎯 **Tujuan Aplikasi**  
- Memberikan pengalaman mendengarkan musik dengan nuansa mellow yang menenangkan.  
- Menyediakan fitur dasar pemutar musik seperti *play, pause, next, previous,* dan *lyrics view*.  
- Menghadirkan antarmuka yang minimalis, elegan, dan mudah digunakan.  
- Mendukung mode **Light** dan **Dark** agar nyaman di berbagai kondisi pencahayaan.  
- Menjadi dasar pengembangan aplikasi musik yang lebih kompleks di masa depan.

---

🧩 **Daftar Halaman dan Fungsinya**

| Halaman | Nama File | Fungsi Utama |
|----------|------------|---------------|
| Get Started | `get_started.dart` | Halaman pembuka aplikasi yang memperkenalkan konsep dan tombol mulai. |
| Choose Mode | `choose_mode.dart` | Menyediakan pilihan tampilan Light/Dark sebelum masuk ke menu utama. |
| Login Page | `login_page.dart` | Form login bagi pengguna yang sudah memiliki akun. |
| Register Page | `register_page.dart` | Form registrasi pengguna baru untuk membuat akun. |
| Home Page | `home_page.dart` | Menampilkan daftar lagu, rekomendasi playlist, dan musik favorit. |
| Player Page | `player_page.dart` | Memutar lagu, menampilkan cover, kontrol musik, serta lirik. |
| Search Page | `search_page.dart` | Pencarian lagu, artis, atau playlist berdasarkan kata kunci. |
| Profile Page | `profile_page.dart` | Menampilkan informasi pengguna dan opsi pengaturan akun. |

---

💾 **Pengolahan Data Dummy**  
Pada versi ini, semua data yang ditampilkan dalam aplikasi masih bersifat **dummy** dan disimpan secara lokal.  
Data mencakup daftar lagu, informasi pengguna, serta playlist sederhana untuk keperluan demonstrasi.

**Contoh struktur data dummy (dalam bentuk JSON):**

```json
{
  "user": {
    "name": "Naufal",
    "avatar": ""
  },
  "songs": [
    {
      "id": 1,
      "title": "Faded Memories",
      "artist": "Velody Sounds",
      "duration": "03:45"
    },
    {
      "id": 2,
      "title": "Midnight Rain",
      "artist": "Mellow Tune",
      "duration": "04:10"
    }
  ]
}

```

⚙️ Cara Penggunaan Aplikasi

Clone Repository

git clone https://github.com/username/velody.git


Masuk ke Folder Project

cd velody


Jalankan Perintah Get Packages

flutter pub get


Jalankan Aplikasi

flutter run


Aplikasi dapat dijalankan di emulator Android/iOS maupun perangkat fisik.

🗂️ Struktur Folder Project

lib/
├── common/
│   └── widgets/
│       └── button/
│           └── basic_app_button.dart
├── core/
│   └── configs/
│       ├── assets/
│       │   ├── app_images.dart
│       │   └── app_vector.dart
│       └── theme/
│           └── app_theme.dart
├── features/
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   ├── home/
│   │   ├── home_page.dart
│   │   └── player_page.dart
│   ├── profile/
│   │   └── profile_page.dart
│   └── search/
│       └── search_page.dart
└── main.dart


🖼️ Preview Tampilan (Contoh)
(Tambahkan screenshot jika tersedia di folder assets/screenshots)

📱 Get Started → Choose Mode → Home Page → Player Page

💡 Teknologi yang Digunakan

Flutter (Framework utama)

Dart (Bahasa pemrograman)

Provider / Bloc (State Management)

Shared Preferences (Penyimpanan lokal)

Google Fonts & Lottie (UI Enhancement)

👨‍💻 Dibuat oleh
Naufal Maulana rafiq 
📚 UTS Pemrograman Mobile – 2025

✨ “Listen with calm, live with harmony.” — Velody