# 🎵 Velody — Aplikasi Pemutar Musik Mellow

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-UAS%20Final%20Project-blue?style=for-the-badge)

---

📌 **Deskripsi Aplikasi** **Velody** adalah aplikasi pemutar musik berbasis **Flutter** yang dirancang untuk menghadirkan pengalaman streaming musik yang *seamless* dan elegan. Aplikasi ini kini telah terintegrasi penuh dengan **Cloud Backend** untuk manajemen pengguna dan konten secara *real-time*.

Aplikasi ini dikembangkan sebagai **Proyek Akhir (UAS) Pemrograman Mobile**, berevolusi dari versi sebelumnya (UTS) dengan penambahan fitur autentikasi, database online, dan manajemen state yang lebih kompleks.

---

🎯 **Fitur Utama** - **User Authentication:** Login dan Register aman menggunakan Firebase Auth.
- **Cloud Streaming:** Memutar lagu secara online tanpa perlu menyimpan file di perangkat.
- **Playlist Management:** Membuat playlist pribadi dan menambahkan lagu favorit.
- **Theme System:** Dukungan **Dark Mode** dan **Light Mode** yang persisten (tersimpan).
- **Responsive Player:** Kontrol musik lengkap (Play, Pause, Shuffle, Loop) dengan tampilan cover album estetik.

---

🛠 **Arsitektur & Teknologi**

Aplikasi ini dibangun menggunakan prinsip **Clean Architecture** dengan pemisahan *Presentation Layer*, *Business Logic*, dan *Data Layer*.

| Kategori | Teknologi | Keterangan |
|----------|------------|---------------|
| **Framework** | Flutter SDK | UI & Logic utama. |
| **Language** | Dart | Bahasa pemrograman. |
| **State Management** | BLoC & Hydrated BLoC | Mengatur state aplikasi dan tema persisten. |
| **Backend** | Firebase Auth | Manajemen sesi pengguna (Login/Register). |
| **Database** | Cloud Firestore | Database NoSQL untuk metadata lagu & playlist. |
| **Storage/CDN** | GitHub Repository | Hosting aset audio (.mp3) untuk streaming cepat. |

---

🔌 **Penjelasan API & Data (Backend)**

Aplikasi ini tidak menggunakan REST API konvensional, melainkan menggunakan **Firebase SDK** yang berinteraksi langsung dengan database Cloud Firestore. Berikut adalah skema data (Collection) yang digunakan sebagai *endpoint* data:

### 1. Collection: `songs`
Berisi seluruh katalog lagu yang tersedia di aplikasi.
* **Method:** `SongService.getSongs()`
* **Struktur Data (JSON Object):**
    ```json
    {
      "title": "Hericane",
      "artist_name": "LANY",
      "duration": 246,
      "cover_url": "[https://firebasestorage.googleapis.com/.../image.jpg](https://firebasestorage.googleapis.com/.../image.jpg)",
      "audio_url": "[https://raw.githubusercontent.com/naufalmaulanarafiq/velody-assets/main/hericane.mp3](https://raw.githubusercontent.com/naufalmaulanarafiq/velody-assets/main/hericane.mp3)"
    }
    ```

### 2. Collection: `users`
Menyimpan profil pengguna yang terdaftar.
* **Method:** `AuthService.signUp()`
* **Data:** `uid`, `email`, `username`, `created_at`.

### 3. Collection: `playlists`
Menyimpan data playlist yang dibuat oleh user.
* **Method:** `PlaylistService.createPlaylist()`
* **Data:** `name`, `description`, `songs` (Array of Song IDs).

---

🧩 **Daftar Halaman (Sitemap)**

| Halaman | Deskripsi |
|----------|---------------|
| **Splash Screen** | Halaman loading awal untuk inisialisasi Firebase & Aset. |
| **Intro / Get Started** | Halaman pengenalan aplikasi untuk pengguna baru. |
| **Auth (Login/Register)** | Halaman autentikasi untuk akses akun. |
| **Home Page** | Menampilkan Top Albums, Rekomendasi, dan Tab Kategori. |
| **Music Player** | Halaman pemutar musik utama dengan kontrol & lirik. |
| **Playlist / Library** | Menampilkan daftar playlist yang dibuat pengguna. |
| **Profile** | Informasi akun pengguna dan pengaturan tema. |

---

⚙️ **Cara Instalasi & Menjalankan**

Ikuti langkah berikut untuk menjalankan project di mesin lokal Anda:

1. **Clone Repository**
   ```bash
   git clone [https://github.com/naufalmaulanarafiq/velody.git](https://github.com/naufalmaulanarafiq/velody.git)
2. **Masuk ke Direktori Project**
   ```Bash
   cd velody
3. **Install Dependencies Pastikan koneksi internet stabil untuk mengunduh package Flutter & Firebase.**
   ```Bash
   flutter pub get
4. **Konfigurasi Firebase (Penting)**
  Pastikan file google-services.json sudah tersedia di folder android/app/.
  Jika belum, unduh dari Firebase Console project Anda.

5. **Jalankan Aplikasi Disarankan menggunakan perintah ini untuk melihat log error jika ada:**
   ```Bash
   flutter run


  👨‍💻 Tim Pengembang Naufal Maulana Rafiq Mahasiswa Teknik Informatika

  Final Project Pemrograman Mobile – 2025

  ✨ “Listen with calm, live with harmony.” — Velody