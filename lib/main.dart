import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMFLASHER Nota',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotaPage extends StatefulWidget {
  @override
  _NotaPageState createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  
  TextEditingController namaController = TextEditingController();
  TextEditingController hpController = TextEditingController();
  TextEditingController hpJenisController = TextEditingController();
  TextEditingController kerusakanController = TextEditingController();
  TextEditingController biayaController = TextEditingController();

  int total = 0;

  // DATA TOKO - BISA DIEDIT DI SINI
  String namaToko = "SMFLASHER";
  String slogan = "SOLUSI PERBAIKAN PONSEL";
  String alamatToko = "Jln Dusun Sorok Desa Darmacaang RT 26 RW 01\nKec. Cikoneng Kab. Ciamis";
  String noHpToko = "085320690367";

  void hitungTotal() {
    setState(() {
      total = int.tryParse(biayaController.text) ?? 0;
    });
  }

  Future<void> simpanDanKirimWA() async {
    final image = await screenshotController.capture();
    if (image == null) return;
    
    final directory = Directory.systemTemp;
    final imagePath = await File('${directory.path}/nota_smflasher.png').create();
    await imagePath.writeAsBytes(image);

    String pesan = """
*NOTA SERVIS $namaToko*
Nama: ${namaController.text}
No HP: ${hpController.text}
Jenis HP: ${hpJenisController.text}
Kerusakan: ${kerusakanController.text}
Biaya: Rp ${total.toString()}

Terima kasih sudah servis di $syamflasher
$dusun sorok rt01 rw02 desa darmacaang kec cikoneng kab ciamis
WA: $085320690367
""";

    await Share.shareFiles([imagePath.path], text: pesan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buat Nota $namaToko'), centerTitle: true),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // HEADER
                Image.asset('assets/logo_smf.png', height: 100),
                SizedBox(height: 8),
                Text(namaToko, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(slogan, style: TextStyle(fontSize: 12)),
                Text(alamatToko, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                Text("WA: $noHpToko", style: TextStyle(fontSize: 12)),
                Divider(height: 30, thickness: 2),
                
                // FORM
                TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama Pelanggan', border: OutlineInputBorder())),
                SizedBox(height: 10),
                TextField(controller: hpController, decoration: InputDecoration(labelText: 'No HP Pelanggan', border: OutlineInputBorder())),
                SizedBox(height: 10),
                TextField(controller: hpJenisController, decoration: InputDecoration(labelText: 'Jenis HP', border: OutlineInputBorder())),
                SizedBox(height: 10),
                TextField(controller: kerusakanController, decoration: InputDecoration(labelText: 'Kerusakan', border: OutlineInputBorder())),
                SizedBox(height: 10),
                TextField(
                  controller: biayaController, 
                  decoration: InputDecoration(labelText: 'Biaya Servis', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => hitungTotal(),
                ),
                SizedBox(height: 20),
                Text("TOTAL: Rp $total", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
                SizedBox(height: 20),

                // TOMBOL
                ElevatedButton.icon(
                  icon: Icon(Icons.whatsapp),
                  label: Text("Simpan Nota & Kirim ke WA", style: TextStyle(fontSize: 16)),
                  onPressed: simpanDanKirimWA,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, 
                    minimumSize: Size(double.infinity, 50),
                    foregroundColor: Colors.white
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
