import 'package:absensi_abang_ppkdb4/models/user_model.dart';
import 'package:absensi_abang_ppkdb4/screens/login_screen.dart';
import 'package:absensi_abang_ppkdb4/services/attendance_service.dart';
import 'package:absensi_abang_ppkdb4/services/preference_handler.dart';
// 🔥 PERBAIKAN: Menggunakan import dari file utility yang menggunakan package intl
import 'package:absensi_abang_ppkdb4/utility/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// Hapus import: import 'package:absensi_abang_ppkdb4/utils/date_util.dart' as DateFormatter;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel? _user;
  bool _isLoading = false;
  // 🔥 Perbaikan: Tambahkan state untuk loading inisial yang terpisah
  bool _isInitialLoading = true;
  String? _initialError; // Pesan error jika gagal load

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // Pastikan _isInitialLoading di set true saat memulai, dan _initialError direset
    // Hanya set state jika ada perubahan (misalnya saat Retry)
    if (_user == null && !_isInitialLoading) {
      setState(() {
        _isInitialLoading = true;
        _initialError = null;
      });
    }

    final profile = await AttendanceService.getProfile();

    // Memberikan waktu sedikit untuk UX
    await Future.delayed(const Duration(milliseconds: 500));

    if (profile == null) {
      // Jika profile gagal dimuat
      final token = await PreferenceHandler.getToken();
      if (token == null || token.isEmpty) {
        // Jika token hilang, paksa logout
        _showSnackbar('Sesi berakhir. Mohon login kembali.');
        _logout();
      } else {
        // Token ada, tapi API gagal (kemungkinan koneksi/401/403)
        setState(() {
          _user = null; // Tetap null
          _isInitialLoading = false; // Hentikan spinner loading inisial
          _initialError =
              'Gagal memuat profil. Cek koneksi internet dan status server Anda, lalu coba lagi.';
        });
      }
    } else {
      // Berhasil
      setState(() {
        _user = profile;
        _isInitialLoading = false;
        _initialError = null;
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('Layanan lokasi dinonaktifkan.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        _showSnackbar('Izin lokasi ditolak. Aktifkan di pengaturan.');
        return null;
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _showSnackbar('Gagal mengambil lokasi GPS.');
      return null;
    }
  }

  Future<void> _handleCheckIn() async {
    if (_user == null) {
      _showSnackbar('Harap muat profil terlebih dahulu.');
      return;
    }
    setState(() => _isLoading = true);
    final pos = await _getCurrentLocation();
    if (pos != null) {
      final msg = await AttendanceService.checkIn(pos.latitude, pos.longitude);
      _showSnackbar(msg);
    } else {
      _showSnackbar('Absen Masuk dibatalkan karena gagal mendapatkan lokasi.');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _handleCheckOut() async {
    if (_user == null) {
      _showSnackbar('Harap muat profil terlebih dahulu.');
      return;
    }
    setState(() => _isLoading = true);
    final pos = await _getCurrentLocation();
    if (pos != null) {
      final msg = await AttendanceService.checkOut(pos.latitude, pos.longitude);
      _showSnackbar(msg);
    } else {
      _showSnackbar('Absen Pulang dibatalkan karena gagal mendapatkan lokasi.');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _logout() async {
    await PreferenceHandler.removeToken();
    await PreferenceHandler.saveLogin(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // Widget yang akan ditampilkan ketika gagal memuat profil
  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              _initialError ?? 'Terjadi kesalahan saat memuat data.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isInitialLoading ? null : _loadProfile,
              icon: const Icon(Icons.refresh),
              label: Text(_isInitialLoading ? 'Memuat...' : 'Coba Lagi'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _logout,
              child: const Text('Logout & Login Ulang'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_isInitialLoading) {
      // Tampilkan spinner penuh saat loading inisial
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_user == null) {
      // Tampilkan error screen jika loading inisial sudah selesai tapi _user null
      bodyContent = _buildErrorScreen();
    } else {
      // Tampilkan dashboard jika _user sudah ada
      bodyContent = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${_user!.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Hari ini: ${DateUtility.getTodayDate()}", // 🔥 Perbaikan pemanggilan
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCheckIn,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Absen Masuk"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCheckOut,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Absen Pulang"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Absensi"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: bodyContent,
    );
  }
}
