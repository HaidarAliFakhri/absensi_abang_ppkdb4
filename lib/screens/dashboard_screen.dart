import 'package:absensi_abang_ppkdb4/models/absensi_model.dart';
import 'package:absensi_abang_ppkdb4/models/user_model.dart';
import 'package:absensi_abang_ppkdb4/screens/login_screen.dart';
import 'package:absensi_abang_ppkdb4/services/attendance_service.dart';
import 'package:absensi_abang_ppkdb4/services/preference_handler.dart';
import 'package:absensi_abang_ppkdb4/utility/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel? _user;
  AbsensiModel? _todayAttendance;
  bool _isLoading = false;
  bool _isInitialLoading = true;
  String? _initialError;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadTodayPresence();
  }

  // LOAD PROFILE
  Future<void> _loadProfile() async {
    final profile = await AttendanceService.getProfile();
    await Future.delayed(const Duration(milliseconds: 400));

    if (profile == null) {
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        _showSnackbar('Sesi berakhir. Mohon login kembali.');
        _logout();
      } else {
        setState(() {
          _initialError = 'Gagal memuat profil. Coba lagi.';
          _isInitialLoading = false;
        });
      }
    } else {
      setState(() {
        _user = profile;
        _initialError = null;
        _isInitialLoading = false;
      });
    }
  }

  // LOAD TODAY PRESENCE
  Future<void> _loadTodayPresence() async {
    final data = await AttendanceService.getTodayPresence();
    setState(() => _todayAttendance = data);
  }

  // GET CURRENT GPS
  Future<Position?> _getCurrentLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      _showSnackbar('Layanan lokasi dinonaktifkan.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnackbar('Izin lokasi ditolak.');
        return null;
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _showSnackbar('Gagal mengambil lokasi.');
      return null;
    }
  }

  // HANDLE CHECK-IN
  Future<void> _handleCheckIn() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    final pos = await _getCurrentLocation();

    if (pos != null) {
      final msg = await AttendanceService.checkIn(pos.latitude, pos.longitude);
      _showSnackbar(msg);
      _loadTodayPresence();
    }

    setState(() => _isLoading = false);
  }

  // HANDLE CHECK-OUT
  Future<void> _handleCheckOut() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    final pos = await _getCurrentLocation();

    if (pos != null) {
      final msg = await AttendanceService.checkOut(pos.latitude, pos.longitude);
      _showSnackbar(msg);
      _loadTodayPresence();
    }

    setState(() => _isLoading = false);
  }

  // HANDLE AJUKAN IZIN
  Future<void> _showIzinDialog() async {
    final TextEditingController alasanC = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Ajukan Izin"),
          content: TextField(
            controller: alasanC,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Masukkan alasan izin...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Kirim"),
              onPressed: () async {
                Navigator.pop(context);

                if (alasanC.text.trim().isEmpty) {
                  _showSnackbar("Alasan izin tidak boleh kosong.");
                  return;
                }

                setState(() => _isLoading = true);

                final res = await AttendanceService.izin(alasanC.text.trim());
                _showSnackbar(res);

                await _loadTodayPresence();

                setState(() => _isLoading = false);
              },
            ),
          ],
        );
      },
    );
  }

  // LOGOUT
  Future<void> _logout() async {
    await PreferenceHandler.removeToken();
    await PreferenceHandler.saveLogin(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // SNACKBAR
  void _showSnackbar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ERROR SCREEN
  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              _initialError ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProfile,
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
            ),
            TextButton(
              onPressed: _logout,
              child: const Text("Logout & Login Ulang"),
            ),
          ],
        ),
      ),
    );
  }

  // MAIN UI
  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) {
      return Scaffold(body: _buildErrorScreen());
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Assalamualaikum, ${_user!.name}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
              ],
            ),

            Text(
              "Hari ini: ${DateUtility.getTodayDate()}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ABSEN BUTTONS
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

            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _showIzinDialog,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Ajukan Izin"),
              ),
            ),

            const SizedBox(height: 20),

            // STATUS HARI INI
            Text(
              "Status Hari Ini:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _todayAttendance == null
                ? const Text("Belum ada absensi hari ini.")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${_todayAttendance!.status}"),
                      if (_todayAttendance!.checkInTime != null)
                        Text("Check-in: ${_todayAttendance!.checkInTime}"),
                      if (_todayAttendance!.alasanIzin != null)
                        Text("Izin: ${_todayAttendance!.alasanIzin}"),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
