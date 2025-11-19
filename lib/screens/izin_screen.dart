import 'package:absensi_abang_ppkdb4/services/api_absensi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IzinScreen extends StatefulWidget {
  const IzinScreen({super.key});

  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> {
  final alasanC = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool loading = false;

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> submitIzin() async {
    if (alasanC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alasan tidak boleh kosong")),
      );
      return;
    }

    setState(() => loading = true);

    final date = DateFormat("yyyy-MM-dd").format(selectedDate);

    final res = await AbsensiApi.izin(date: date, alasan: alasanC.text);

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res?["message"] ?? "Gagal mengirim izin")),
    );

    if (res?["data"] != null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd MMM yyyy").format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text("Pengajuan Izin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text("Tanggal Izin: $dateFormat"),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: pickDate,
              ),
            ),

            TextField(
              controller: alasanC,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Alasan Izin",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : submitIzin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Kirim Izin"),
            ),
          ],
        ),
      ),
    );
  }
}
