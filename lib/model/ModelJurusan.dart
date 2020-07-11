import 'package:firebase_database/firebase_database.dart';

class Jurusan{
  final String key;
  final String namaJurusan;
  final String deskripsi;
  bool completed;

  Jurusan({this.key, this.namaJurusan, this.deskripsi, this.completed});

  Jurusan.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        namaJurusan = snapshot.value['namaJurusan'],
        deskripsi = snapshot.value['deskripsi'],
        completed = snapshot.value['completed'];

  Map<String, dynamic> toJson() => {
    'namaJurusan' : namaJurusan,
    'deskripsi' : deskripsi,
    'completed' : completed
  };
}