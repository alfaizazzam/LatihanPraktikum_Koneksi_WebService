import 'package:flutter/material.dart'; // Import pustaka Material untuk membangun UI Flutter.
import 'package:http/http.dart'
    as http; // Import pustaka http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Import pustaka dart:convert untuk mengonversi JSON.

class University {
  String name; // Atribut untuk menyimpan nama universitas.
  String website; // Atribut untuk menyimpan situs web universitas.

  University({required this.name, required this.website}); // Constructor.

  // Factory method untuk membuat instance University dari JSON.
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'], // Ambil nama universitas dari JSON.
      website: json['web_pages']
          [0], // Ambil situs web pertama dari daftar web_pages di JSON.
    );
  }
}

void main() {
  runApp(MyApp()); // Jalankan aplikasi Flutter.
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Buat dan kembalikan instance dari MyAppState.
  }
}

class MyAppState extends State<MyApp> {
  late Future<List<University>>
      futureUniversities; // Variabel untuk menampung hasil universitas dari API.

  // URL untuk memanggil API universitas di Indonesia.
  String url = "http://universities.hipolabs.com/search?country=Indonesia";

  // Fungsi untuk melakukan permintaan HTTP dan mendapatkan data universitas dari API.
  Future<List<University>> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Lakukan permintaan HTTP GET ke URL.

    if (response.statusCode == 200) {
      // Jika server mengembalikan 200 OK (berhasil),
      // parse JSON dan kembalikan daftar universitas.
      Iterable list = jsonDecode(response.body); // Ubah JSON menjadi iterable.
      return List<University>.from(list.map((model) => University.fromJson(
          model))); // Mapping setiap item JSON menjadi instance University.
    } else {
      // Jika gagal (bukan 200 OK), lempar exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities =
        fetchData(); // Set futureUniversities dengan hasil permintaan data.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Universitas di Indonesia', // Judul aplikasi.
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Universitas'), // Judul AppBar.
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future: futureUniversities, // Tentukan future yang akan dibangun.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika sudah ada data yang tersedia, tampilkan ListView dengan daftar universitas.
                return ListView.builder(
                  itemCount: snapshot.data!.length, // Jumlah item di ListView.
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot
                          .data![index].name), // Tampilkan nama universitas.
                      subtitle: Text(snapshot.data![index]
                          .website), // Tampilkan situs web universitas.
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika ada kesalahan, tampilkan pesan kesalahan.
                return Text('${snapshot.error}');
              }
              // Default: tampilkan spinner loading.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
