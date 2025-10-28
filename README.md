🎵 Velody App
📌 Deskripsi Singkat

Velody App adalah aplikasi mobile berbasis Flutter yang dirancang untuk memberikan pengalaman mendengarkan musik yang tenang, elegan, dan berkarakter mellow.
Aplikasi ini dikembangkan sebagai proyek UTS Pemrograman Mobile, dengan tujuan menghadirkan platform musik sederhana yang tetap menonjol secara estetika melalui desain antarmuka yang modern dan minimalis.

🎯 Tujuan Aplikasi

Menyediakan pengalaman pemutaran musik yang intuitif dan nyaman.

Memberikan suasana visual yang lembut dan elegan melalui tema warna “Deep Mauve”.

Menjadi aplikasi musik dengan fokus pada keteraturan desain, bukan sekadar fungsionalitas.

Menjadi dasar pengembangan aplikasi musik cerdas di masa depan.

🧩 Daftar Halaman dan Fungsinya
Halaman	Nama File	Fungsi Utama
Get Started Page	get_started.dart	Tampilan pembuka aplikasi dengan tombol untuk memulai.
Choose Mode Page	choose_mode.dart	Halaman untuk memilih tema terang atau gelap sebelum masuk ke aplikasi.
Login Page	login_page.dart	Halaman untuk pengguna masuk ke akun mereka.
Register Page	register_page.dart	Halaman pendaftaran akun baru.
Home Page	home_page.dart	Menampilkan daftar lagu dan rekomendasi playlist.
Player Page	player_page.dart	Menampilkan cover lagu, tombol kontrol, dan lirik.
Search Page	search_page.dart	Pencarian lagu, artis, atau playlist.
Profile Page	profile_page.dart	Menampilkan data pengguna dan pengaturan akun.
💾 Pengolahan Data Dummy

Aplikasi Velody saat ini menggunakan data statis (dummy) untuk menampilkan daftar lagu, playlist, dan informasi pengguna.
Data disimpan secara lokal menggunakan struktur list sederhana pada file .dart, yang nantinya dapat dikembangkan menjadi basis data dinamis (misalnya menggunakan Firebase atau SQLite).

Contoh struktur data dummy (dalam bentuk map Dart):

final songs = [
  {
    "title": "Mellow Breeze",
    "artist": "Aurora Lane",
    "duration": "3:45",
    "cover": "assets/images/mellow_breeze.jpg"
  },
  {
    "title": "Evening Glow",
    "artist": "Velora",
    "duration": "4:12",
    "cover": "assets/images/evening_glow.jpg"
  }
];

📱 Cara Menggunakan Aplikasi

Menjalankan Aplikasi

Buka terminal pada direktori proyek.

Jalankan perintah berikut untuk memulai aplikasi:

flutter run


Aplikasi akan tampil di emulator atau perangkat fisik yang terhubung.

Navigasi Awal

Saat pertama kali dijalankan, pengguna akan diarahkan ke halaman Get Started.

Setelah itu, masuk ke Choose Mode untuk memilih tema tampilan (light atau dark).

Login & Register

Pengguna baru dapat membuat akun melalui Register Page.

Setelah terdaftar, pengguna dapat masuk melalui Login Page dan diarahkan ke halaman utama.

Menjelajahi Musik

Di Home Page, pengguna dapat melihat daftar lagu dan playlist yang direkomendasikan.

Tekan salah satu lagu untuk membuka Player Page, di mana pengguna bisa memutar, menjeda, atau melihat lirik.

Pencarian dan Profil

Gunakan Search Page untuk mencari lagu atau artis tertentu.

Profile Page memungkinkan pengguna melihat informasi akun dan mengubah mode tampilan.

🎨 Desain Antarmuka (UI/UX)

Konsep Desain:
Gaya minimalis modern dengan palet warna lembut yang memberikan kesan elegan dan menenangkan.

Palet Warna:

Primary: Deep Mauve #A78BFA

Secondary: Lavender Grey #B3A0FF

Background Light: #F9F9FB

Background Dark: #121212

Text Light: #3A3A3A

Text Dark: #E0E0E0

Tipografi:
Menggunakan font Satoshi, memberikan kesan modern dan mudah dibaca.

Inspirasi Desain:
Terinspirasi dari tampilan visual Spotify, dengan sentuhan tone warna yang lebih lembut dan calm sesuai karakter Velody.

👩‍💻 Informasi Pengembang
Nama	NIM	Kelas	Program Studi	Universitas
Naufal Maulana	230605110003	A	Teknik Informatika	UIN Maulana Malik Ibrahim Malang
🌟 Fitur yang Akan Dikembangkan

Integrasi API Musik untuk pemutaran lagu asli.

Fitur Playlist Pribadi dan sistem favorit.

Fitur Lyric Synchronization secara real-time.

Mode Dark/Light otomatis berdasarkan preferensi sistem.

📚 Lisensi

Proyek ini dibuat sebagai bagian dari Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile.
Seluruh hak cipta hanya digunakan untuk kepentingan akademik dan tidak untuk tujuan komersial.