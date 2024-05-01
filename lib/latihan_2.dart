import 'package:flutter/material.dart'; // Import pustaka Material untuk membangun UI Flutter.
import 'package:http/http.dart'
    as http; // Import pustaka http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Import pustaka dart:convert untuk mengonversi JSON.

void main() {
  runApp(const MyApp()); // Jalankan aplikasi Flutter.
}

// Menampung data hasil pemanggilan API.
class Activity {
  String aktivitas; // Atribut untuk menyimpan aktivitas.
  String jenis; // Atribut untuk menyimpan jenis aktivitas.

  Activity({required this.aktivitas, required this.jenis}); // Constructor.

  // Map dari JSON ke atribut.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Ambil nilai 'activity' dari JSON.
      jenis: json['type'], // Ambil nilai 'type' dari JSON.
    );
  }
}

// Kelas utama aplikasi Flutter.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Buat dan kembalikan instance dari MyAppState.
  }
}

// Kelas State untuk MyApp.
class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; // Variabel untuk menampung hasil aktivitas dari API.
  String url =
      "https://www.boredapi.com/api/activity"; // URL untuk memanggil API.

  // Fungsi untuk menginisialisasi futureActivity.
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: ""); // Kembalikan aktivitas kosong.
  }

  // Fungsi untuk melakukan permintaan HTTP dan mendapatkan data aktivitas dari API.
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Lakukan permintaan HTTP GET ke URL.
    if (response.statusCode == 200) {
      // Jika status code 200 OK (berhasil),
      // parse JSON dan kembalikan instance Activity.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika gagal (bukan 200 OK), lempar exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Set futureActivity dengan hasil inisialisasi.
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity =
                      fetchData(); // Set futureActivity dengan hasil permintaan data baru.
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Tentukan future yang akan dibangun.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika sudah ada data yang tersedia, tampilkan aktivitas dan jenis.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Tampilkan aktivitas.
                      Text(
                          "Jenis: ${snapshot.data!.jenis}") // Tampilkan jenis aktivitas.
                    ]));
              } else if (snapshot.hasError) {
                // Jika ada kesalahan, tampilkan pesan kesalahan.
                return Text('${snapshot.error}');
              }
              // Default: tampilkan spinner loading.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
