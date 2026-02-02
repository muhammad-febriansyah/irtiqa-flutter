# Setup Keystore untuk Aplikasi Irtiqa

## 1. Generate Keystore

Jalankan perintah berikut di terminal:

```bash
# Buat direktori keystore jika belum ada
mkdir -p /Applications/keystore

# Generate keystore
keytool -genkey -v -keystore /Applications/keystore/irtiqa-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias irtiqa-key
```

## 2. Informasi Keystore (Gunakan saat generate)

Ketika diminta informasi, masukkan:
- **Password**: `irtiqa2024` (untuk storePassword dan keyPassword)
- **Nama depan dan nama belakang**: `Irtiqa Team`
- **Nama unit organisasi**: `Development`
- **Nama organisasi**: `Irtiqa`
- **Nama Kota atau Daerah**: `Bogor`
- **Nama Negara Bagian atau Provinsi**: `Jawa Barat`
- **Kode negara dua-huruf**: `ID`

## 3. Verifikasi Keystore

Setelah keystore dibuat, verifikasi dengan:

```bash
keytool -list -v -keystore /Applications/keystore/irtiqa-release-key.jks -alias irtiqa-key
```

Password: `irtiqa2024`

## 4. Build Release APK

```bash
cd /Applications/mobile/irtiqa
flutter build apk --release
```

APK akan tersimpan di: `build/app/outputs/flutter-apk/app-release.apk`

## 5. Build App Bundle (untuk Google Play Store)

```bash
flutter build appbundle --release
```

Bundle akan tersimpan di: `build/app/outputs/bundle/release/app-release.aab`

## ⚠️ PENTING - Backup Keystore

**SANGAT PENTING**: Backup file keystore `/Applications/keystore/irtiqa-release-key.jks` dan password `irtiqa2024` di tempat yang aman!

Jika keystore hilang, Anda TIDAK BISA update aplikasi di Play Store.

## Lokasi File Konfigurasi

- Keystore: `/Applications/keystore/irtiqa-release-key.jks`
- Config: `/Applications/mobile/irtiqa/android/key.properties`
- Password: `irtiqa2024` (storePassword & keyPassword)
- Alias: `irtiqa-key`
