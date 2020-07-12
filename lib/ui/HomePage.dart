import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign/main.dart';
import 'package:google_sign/model/ModelJurusan.dart';
import 'package:google_sign/ui/AddJurusan.dart';
import 'package:google_sign/ui/ListJurusan.dart';
import 'package:google_sign/ui/LokasiPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({this.user, this.googleSignIn});
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Jurusan> _jurusanList = List();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.user.displayName,
              style: TextStyle(fontSize: 16),
            ),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 150,
              child: Image(
                image: NetworkImage(widget.user.photoUrl),
              ),
            ),
            decoration: BoxDecoration(color: Colors.orange),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('List Jurusan'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListJurusan()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Tambah Jurusan'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddJurusan()));
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Lokasi PNP'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LokasiPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              _signOut();
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: Text('Politeknik Negeri Padang'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            iconSize: 24.0,
            onPressed: () {
              _signOut();
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Carousel(
              autoplay: true,
              indicatorBgPadding: 4.0,
              dotBgColor: Colors.transparent,
              dotColor: Colors.orange,
              images: [
                AssetImage('images/pnp2.jpg'),
                AssetImage('images/pnpp.jpg'),
                AssetImage('images/pnppp.jpg'),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              'Politeknik Negeri Padang adalah lembaga Pendidikan vokasional yang dalam penyelenggaraan pendidikan menitik beratkan pada pencapaian kompetensi sesuai kebutuhan dunia industri. Semenjak berdiri pada tahun 1987 Politeknik Negeri Padang telah menghasilkan lulusan yang tersebar di berbagai instansi pemerintah, swasta baik dalam maupun di luar negeri.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
              textAlign: TextAlign.justify,
            ),
          )),
          Container(
              child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
            child: Text(
              'Sebagai lembaga pendidikan , Politeknik Negeri Padang mengemban misi untuk melaksanakan kegiatan pendidikan. Sesuai potensi sumber daya manusia yang dimiliki oleh Politeknik Negeri Padang , maka jurusan dan program studi yang dikelola semakin bertambah seiring kebutuhan dunia industri. penelitian dan pengabdian masyarakat yang semuanya diarahkan untuk peningkatan kesejahteraan masyarakat profesional dan berorientasi pada praktek industri.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
              textAlign: TextAlign.justify,
            ),
          )),

          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
                child: Text(
                  'Profil Politeknik Negeri Padang ini disusun untuk lebih memberikan gambaran tentang Politeknik Negeri Padang beserta program studi dan unit jasa layanan yang dapat diberikan kepada masyarakat, sehingga keberadaan Politeknik Negeri Padang dapat lebih bermanfaat bagi masyarakat . Semoga kehadiran buku profil ini dapat mencapai tujuan.',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                  textAlign: TextAlign.justify,
                ),
              )),
        ],
      ),
    );
  }
}
