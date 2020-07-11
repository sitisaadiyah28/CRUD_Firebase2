import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign/main.dart';
import 'package:google_sign/model/ModelJurusan.dart';
import 'package:google_sign/ui/AddJurusan.dart';
import 'package:google_sign/ui/DetailJurusan.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ListJurusan extends StatefulWidget {
  ListJurusan({this.user, this.googleSignIn});
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  @override
  _ListJurusanState createState() => _ListJurusanState();
}

class _ListJurusanState extends State<ListJurusan> {
  List<Jurusan> _jurusanList = List();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  DatabaseReference _jurusanRef;

  final _jurusanController = TextEditingController();
  final _deskripsiController = TextEditingController();

  StreamSubscription<Event> _onJurusanAddedSubscription;
  StreamSubscription<Event> _onJurusanChangedSubscription;

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  void _signOut() {
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: new Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(widget.user.photoUrl),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.user.displayName,
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Sign Out?",
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.googleSignIn.signOut();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Login()));
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check, color: Colors.green),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      Text("Yes"),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      Text("Cancel"),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, child: alertDialog);
  }

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
        title: Text('List Jurusan'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: _showListJurusan(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder:( BuildContext context)=> new AddJurusan())
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        elevation: 40.0,
        color: Colors.orange,
        child: ButtonBar(
          children: <Widget>[],
        ),
      ),
    );
  }

  Widget _showListJurusan() {
    if (_jurusanList.length > 0) {
      return ListView.builder(
        itemCount: _jurusanList.length,
        itemBuilder: (context, index) {
          Jurusan jurusan = _jurusanList[index];
          return Dismissible(
            key: Key(jurusan.key),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) async {
              _deleteJurusan(jurusan.key, index);
            },
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    new MaterialPageRoute(builder:( BuildContext context)=> new DetailJurusan(
                      namaJurusan : jurusan.namaJurusan,
                      deskripsi   : jurusan.deskripsi
                    ))
                );
              },
              child: Card(
                elevation: 10,
                child: ListTile(
                  title: Text(
                    jurusan.namaJurusan,
                    style: TextStyle(fontSize: 20.0, color: Colors.green),
                  ),
                  trailing: IconButton(
                    icon: (jurusan.completed)
                        ? Icon(
                            Icons.done_outline,
                            color: Colors.green,
                            size: 20.0,
                          )
                        : Icon(
                            Icons.done,
                            color: Colors.grey,
                            size: 20.0,
                          ),
                    onPressed: () {
                      _updateJurusan(jurusan);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('Tidak ada Jurusan'),
      );
    }
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
