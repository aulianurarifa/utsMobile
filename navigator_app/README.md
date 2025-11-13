# Lovely Dashboard App

Lovely Dashboard App adalah aplikasi Flutter bertema  yang menyajikan berbagai halaman seperti dashboard, biodata, cuaca, kalkulator, berita, dan kontak. Proyek ini berfokus pada nuansa visual retro dengan kombinasi gradasi pastel, font pixel/rounded, serta stiker-stiker dekoratif.

## Fitur Utama

- **Dashboard :** Menampilkan ringkasan jadwal sholat harian, todo list interaktif dengan gaya retro, serta ragam stiker dekoratif.
- **Biodata Dinamis:** Data profil dapat diedit langsung dari UI melalui form bottom sheet dan tersimpan di state aplikasi.
- **Halaman Cuaca, Berita, Kalkulator, Kontak:** Setiap halaman menggunakan styling konsisten bertema pastel-pixel.
- **Responsif & Scrollable:** Sebagian besar halaman dibangun dengan `SingleChildScrollView` untuk kenyamanan pengguna di berbagai ukuran layar.

## Prasyarat

- [Flutter](https://flutter.dev/docs/get-started/install) >= 3.22
- Dart SDK (bundled dengan Flutter)
- Editor pilihan (Visual Studio Code, Android Studio, IntelliJ, dsb.)

## Menjalankan Proyek

```bash
flutter pub get
flutter run
```

Perintah di atas akan mengambil dependency yang diperlukan lalu menjalankan aplikasi di device/emulator yang tersedia.

## Struktur Folder Penting

- `lib/`
	- `main.dart`: entry point aplikasi.
	- `dashboard_screen.dart`: routing utama, memuat navigasi ke setiap halaman.
	- `pages/`
		- `dashboard_home_page.dart`: halaman dashboard .
		- `biodata_page.dart`: biodata dengan form edit.
		- `cuaca_page.dart`, `berita_page.dart`, `kalkulator_page.dart`, `kontak_page.dart`: halaman tematik lainnya.
- `assets/images/`: aset gambar/stiker yang digunakan untuk memperkuat tema retro.

## Penyesuaian

- **Mengubah Biodata:** Buka aplikasi, masuk ke halaman Biodata, ketuk tombol `Edit`, ubah data pada form, lalu pilih `Simpan`.
- **Menambahkan Todo:** Di Dashboard, tulis agenda baru pada bidang input dan tekan tombol tambah.
- **Modifikasi Tema:** Gaya warna, font, dan dekorasi bisa ditemukan langsung di masing-masing file halaman; gunakan `GoogleFonts` dan gradasi warna sesuai selera.

## Catatan Tambahan

- Proyek menggunakan font Google VT323 dan Fredoka untuk memberikan nuansa retro-futuristic.
- Sebagian widget mengadopsi custom painter serta efek blur/gradient untuk menjaga konsistensi tema.
- Bila Anda melakukan perubahan besar, jalankan `flutter analyze` dan `flutter test` (jika tersedia) guna memastikan tidak ada regresi.


