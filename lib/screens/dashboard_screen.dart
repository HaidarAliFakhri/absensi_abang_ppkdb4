import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String username = "Budi"; // ambil dari provider / API
  double? lat;
  double? lng;

  Future<void> getLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      lat = pos.latitude;
      lng = pos.longitude;
    });
  }

  Future<void> checkIn() async {
    await getLocation();
    // panggil API check in POST /absen-check-in
  }

  Future<void> checkOut() async {
    await getLocation();
    // panggil API check out POST /absen-check-out
  }

  @override
  Widget build(BuildContext context) {
    String today = DateTime.now().toString().substring(0, 10);

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, $username 👋",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Hari ini: $today",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: checkIn,
                    child: const Text("Absen Masuk"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: checkOut,
                    child: const Text("Absen Pulang"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            if (lat != null) Text("Lokasi Anda: $lat , $lng"),

            const SizedBox(height: 20),
            Container(
              height: 160,
              width: double.infinity,
              color: Colors.blue[100],
              child: const Center(child: Text("Mini Google Map (opsional)")),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("Statistik Absen Anda Hari Ini"),
            ),
          ],
        ),
      ),
    );
  }
}
