🎵 **Velody — Aplikasi Pemutar Musik Mellow**

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

Contoh struktur data dummy (dalam bentuk JSON):

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

---
📱 **Cara Menggunakan Aplikasi**

1. Menjalankan Aplikasi

Pastikan Flutter SDK telah terinstal.

Buka terminal di direktori proyek, lalu jalankan:

bash
Copy code
flutter pub get
flutter run
Aplikasi akan berjalan di emulator atau perangkat fisik yang terhubung.

2. Get Started & Choose Mode

Pengguna akan diarahkan ke halaman Get Started dan Choose Mode untuk memilih tema tampilan (Light atau Dark).

3. Login / Register

Masuk menggunakan akun yang sudah terdaftar, atau buat akun baru di halaman registrasi.

4. Home Page

Menampilkan daftar lagu dan rekomendasi playlist sesuai suasana mellow.

5. Player Page

Putar lagu yang dipilih, lihat cover, kontrol musik (play, pause, next, previous), dan tampilkan lirik.

6. Search Page

Cari lagu, artis, atau playlist dengan mudah melalui kolom pencarian.

7. Profile Page

Lihat data pengguna dan lakukan pengaturan profil.

🎨 Desain Antarmuka (UI/UX)

Tema Warna Utama: Deep Mauve (#A78BFA) dan Lavender Grey (#B3A0FF).

Mode Tampilan: Light (#F9F9FB) dan Dark (#121212).

Tipografi: Font Satoshi yang memberikan kesan modern dan mudah dibaca.

Konsep Desain: Mengadaptasi elemen Spotify, namun disesuaikan dengan karakter mellow Velody yang lebih lembut dan kalem.

Komponen UI: Menggunakan Column, Row, Container, ListView, dan Stack untuk mendukung tampilan yang responsif dan dinamis.

👩‍💻 Informasi Pengembang

Nama	NIM	Kelas	Program Studi	Universitas
Naufal Maulana	230605110003	A	Teknik Informatika	UIN Maulana Malik Ibrahim Malang

🌟 Fitur yang Akan Dikembangkan

Integrasi API musik untuk pemutaran lagu real-time.

Mode offline agar pengguna dapat mendengarkan musik tanpa internet.

Fitur pembuatan dan penyimpanan playlist pribadi.

Pengaturan equalizer dan preferensi musik.

Sinkronisasi profil pengguna melalui akun Google/Firebase.

📚 Lisensi
Proyek ini dibuat untuk keperluan akademik sebagai tugas Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile.
Segala bentuk distribusi ulang atau penggunaan di luar kepentingan akademik tanpa izin pengembang tidak diperbolehkan.