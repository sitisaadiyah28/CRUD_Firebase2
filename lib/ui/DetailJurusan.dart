import 'package:flutter/material.dart';

class DetailJurusan extends StatefulWidget {
  String namaJurusan, deskripsi;

  DetailJurusan({this.namaJurusan, this.deskripsi});

  @override
  _DetailJurusanState createState() => _DetailJurusanState();
}

class _DetailJurusanState extends State<DetailJurusan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Jurusan'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Text('NAMA  JURUSAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Text(
             widget.namaJurusan
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Text('DESKRIPSI JURUSAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Text(
                widget.deskripsi
            ),
          ),

        ],
      ),
    );
  }
}
