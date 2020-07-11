import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign/model/ModelJurusan.dart';
import 'package:google_sign/ui/ListJurusan.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AddJurusan extends StatefulWidget {
  @override
  _AddJurusanState createState() => _AddJurusanState();
}

class _AddJurusanState extends State<AddJurusan> {
  List<Jurusan> _jurusanList = List();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  DatabaseReference _jurusanRef;

  final _jurusanController = TextEditingController();
  final _deskripsiController = TextEditingController();

  StreamSubscription<Event> _onJurusanAddedSubscription;
  StreamSubscription<Event> _onJurusanChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState

    _jurusanRef = _database.reference().child("jurusans");
    _onJurusanAddedSubscription =
        _jurusanRef.onChildAdded.listen(_onNewJurusan);
    _onJurusanChangedSubscription =
        _jurusanRef.onChildChanged.listen(_onChangedJurusan);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onJurusanAddedSubscription.cancel();
    _onJurusanChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Jurusan'),
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
            child: TextField(
              controller: _jurusanController,
              autofocus: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0)
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Text('DESKRIPSI JURUSAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20),
            child: TextField(
              maxLines: 15,
              controller: _deskripsiController,
              autofocus: true,
              decoration: InputDecoration( border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0)
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
            child: RaisedButton(
              child: Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 16),),
              onPressed: () {
                _addJurusan(_jurusanController.text, _deskripsiController.text);
                Navigator.of(context).push(
                    new MaterialPageRoute(builder:( BuildContext context)=> new ListJurusan())
                );
              },
              color: Colors.deepOrange,
            ),
          )
        ],
      ),
    );
  }

  void _onNewJurusan(Event event) {
    setState(() {
      _jurusanList.add(Jurusan.fromSnapshot(event.snapshot));
    });
  }

  void _onChangedJurusan(Event event) {
    var oldEntry = _jurusanList.singleWhere((jurusan) {
      return jurusan.key == event.snapshot.key;
    });

    setState(() {
      _jurusanList[_jurusanList.indexOf(oldEntry)] =
          Jurusan.fromSnapshot(event.snapshot);
    });
  }

  Future<void> _addJurusan(String namaJurusan, String deskripsi) async {
    if (namaJurusan.length > 0 && deskripsi.length > 0) {
      Jurusan jurusan = Jurusan(
          namaJurusan: namaJurusan, deskripsi: deskripsi, completed: false);
      await _jurusanRef.push().set(jurusan.toJson());
    }
  }

  Future<void> _deleteJurusan(String key, int index) async {
    await _jurusanRef.child(key).remove();
    setState(() {
      _jurusanList.removeAt(index);
    });
  }

  Future<void> _updateJurusan(Jurusan jurusan) async {
    jurusan.completed = !jurusan.completed;
    await _jurusanRef.child(jurusan.key).set(jurusan.toJson());
  }
}
