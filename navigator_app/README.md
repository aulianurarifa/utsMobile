# Lovely Dashboard App

Lovely Dashboard App adalah aplikasi Flutter bertema Y2K yang menyajikan berbagai halaman seperti dashboard, biodata, cuaca, kalkulator, berita, dan kontak. Proyek ini berfokus pada nuansa visual retro dengan kombinasi gradasi pastel, font pixel/rounded, serta stiker-stiker dekoratif.

## Fitur Utama

- **Dashboard :** Menampilkan ringkasan jadwal sholat harian, todo list interaktif dengan gaya retro, serta ragam stiker dekoratif.
- **Biodata Dinamis:** Data profil dapat diedit langsung dari UI melalui form bottom sheet dan tersimpan di state aplikasi.
- **Halaman Cuaca, Berita, Kalkulator, Kontak:** Setiap halaman menggunakan styling konsisten bertema pastel-pixel.
- **Responsif & Scrollable:** Sebagian besar halaman dibangun dengan `SingleChildScrollView` untuk kenyamanan pengguna di berbagai ukuran layar.

## Deskripsi Halaman

- **Dashboard Home:** Halaman utama dengan sapaan personal, ringkasan jadwal sholat yang dapat diperbarui via [_MyQuran API_](https://api.myquran.com/v2/), serta todo list  lengkap dengan tombol tambah cepat.
- **Biodata:** Menampilkan identitaas , daftar detail pribadi, kontak, hobi, serta quote favorit. Terdapat tombol `Edit` yang membuka bottom sheet untuk memperbarui data secara langsung dari UI.
- **Cuaca:** Menyajikan informasi prakiraan cuaca dengan animasi ikon (cerah, berawan, hujan, petir) dan gradien lembut yang diambil dari [_BMKG Cuaca API_](https://ibnux.github.io/BMKG-importer/).
- **Berita:** Daftar kabar terkini yang kini dilengkapi thumbnail gambar, badge sumber, waktu relatif, serta aksi bookmark.
- **Kalkulator:** Kalkulator sederhana dengan tombol warna-warni dan typografi pixel.
- **Kontak:** Kartu informasi kontak penting lengkap dengan tombol aksi cepat dan dekorasi stiker.

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

## Cuplikan Antarmuka

| Dashboard 1 | Dashboard 2 | Biodata | Edit Biodata |
|-------------|-------------|---------|--------------|
| ![Dashboard 1](assets/images/Dashboard1.png) | ![Dashboard 2](assets/images/Dashboard2.png) | ![Biodata](assets/images/Biodata.png) | ![Edit Biodata](assets/images/Edit%20Biodata.png) |

| Cuaca | Berita | Kalkulator | Kontak |
|-------|--------|------------|--------|
| ![Cuaca](assets/images/cuaca.png) | ![Berita](assets/images/berita.png) | ![Kalkulator](assets/images/kalkulator.png) | ![Kontak](assets/images/kontak.png) |



