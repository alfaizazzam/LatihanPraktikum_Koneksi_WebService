import 'dart:convert'; // Mengimpor pustaka dart:convert untuk pengolahan JSON.

void main() {
  // JSON transkrip mahasiswa
  String transkripJson = '''
  {
    "nama": "Al-Faiz Azzam Aryaputra",
    "npm": "22082010022",
    "semester": 4,
    "transkrip_nilai": [ 
      {
        "kode": "MK001", 
        "nama": "Pemrograman Website", 
        "sks": 3, 
        "nilai": "A" 
      },
      {
        "kode": "MK002",
        "nama": "Desain Manajemen Jaringan",
        "sks": 3,
        "nilai": "B+"
      },
      {
        "kode": "MK003",
        "nama": "Basis Data",
        "sks": 3,
        "nilai": "A-"
      }
    ]
  }
  ''';

  // Parsing JSON transkrip mahasiswa
  Map<String, dynamic> transkripMahasiswa = jsonDecode(
      transkripJson); // Menganalisis string JSON dan mengubahnya menjadi objek Map.

  // Menghitung IPK
  double ipk =
      hitungIPK(transkripMahasiswa); // Menghitung IPK dari transkrip mahasiswa.
  print("Nama: ${transkripMahasiswa['nama']}"); // Mencetak nama mahasiswa.
  print("NPM: ${transkripMahasiswa['npm']}"); // Mencetak NPM mahasiswa.
  print(
      "IPK: ${ipk.toStringAsFixed(2)}"); // Mencetak IPK dengan dua digit desimal.

  // Menampilkan transkrip nilai
  print("\nTranskrip Nilai:"); // Header untuk mencetak transkrip nilai.
  for (var mk in transkripMahasiswa['transkrip_nilai']) {
    // Melakukan iterasi melalui setiap nilai mata kuliah.
    print("Nama Mata Kuliah: ${mk['nama']}"); // Mencetak nama mata kuliah.
    print("Kode Mata Kuliah: ${mk['kode']}"); // Mencetak kode mata kuliah.
    print("SKS: ${mk['sks']}"); // Mencetak SKS mata kuliah.
    print("Nilai: ${mk['nilai']}"); // Mencetak nilai mata kuliah.
    print("-----------"); // Garis pembatas antara setiap mata kuliah.
  }
}

// Fungsi untuk menghitung IPK dari JSON transkrip mahasiswa
double hitungIPK(Map<String, dynamic> transkrip) {
  // Fungsi untuk menghitung IPK, menerima objek Map transkrip mahasiswa.
  double totalBobot = 0; // Variabel untuk menyimpan total bobot.
  int totalSKS = 0; // Variabel untuk menyimpan total SKS.

  List<dynamic> transkripNilai =
      transkrip['transkrip_nilai']; // Mendapatkan daftar nilai mata kuliah.
  for (var mk in transkripNilai) {
    // Melakukan iterasi melalui setiap nilai mata kuliah.
    int sks = mk['sks']; // Mendapatkan SKS dari mata kuliah.
    String nilai = mk['nilai']; // Mendapatkan nilai dari mata kuliah.
    double bobot =
        konversiNilaiKeBobot(nilai); // Mengonversi nilai menjadi bobot.
    totalBobot += bobot * sks; // Menambahkan bobot kali SKS ke total bobot.
    totalSKS += sks; // Menambahkan SKS ke total SKS.
  }

  if (totalSKS == 0) return 0; // Menghindari pembagian oleh nol.

  return totalBobot / totalSKS; // Mengembalikan nilai IPK.
}

// Fungsi untuk mengonversi nilai huruf menjadi bobot
double konversiNilaiKeBobot(String nilai) {
  // Fungsi untuk mengonversi nilai huruf menjadi bobot, menerima nilai huruf sebagai argumen.
  switch (nilai) {
    // Melakukan pemilihan berdasarkan nilai huruf.
    case "A":
      return 4.0; // Jika nilai A, mengembalikan bobot 4.0.
    case "A-":
      return 3.7; // Jika nilai A-, mengembalikan bobot 3.7.
    case "B+":
      return 3.4; // Jika nilai B+, mengembalikan bobot 3.4.
    // tambahkan kasus lain jika diperlukan
    default:
      return 0.0; // Mengembalikan 0.0 untuk nilai yang tidak dikenali.
  }
}
