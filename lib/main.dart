
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign/ui/HomePage.dart';
import 'package:google_sign/ui/SplashscreenPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';

void main() => runApp(new MaterialApp(
      home: new SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    ));

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String nama = "";
  String gambar = "";

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    setState(() {
      nama = user.displayName;
      gambar = user.photoUrl;
    });
    _alertDialog();/**/
    Navigator.of(context).push(
        new MaterialPageRoute(builder:( BuildContext context)=> new HomePage(user: user, googleSignIn: googleSignIn))
    );
    print("signed in " + user.displayName);
    return user;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    String nama = "";
    String gambar = "";

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    //assert(!user.isAnonymous);
    //assert(await user.getIdToken() != null);

    //final FirebaseUser currentUser = await _auth.currentUser();
    //assert(user.uid == currentUser.uid);

    _alertDialog();


    //return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  void _alertDialog() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Container(
          height: 230.0,
          child: new Column(
            children: <Widget>[
              new Text(
                "Sudah Login",
                style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              new Divider(),
              new ClipOval(child: new Image.network(gambar)),
              new Text("Anda Login Sebagai $nama"),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new RaisedButton(
                  child: new Text("OK!"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreenPage(

                    )));
                  },
                  color: Colors.green,
                ),
              )
            ],
          )),
    );
    showDialog(context: context, child: alertDialog);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height/4,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Center(
              child: Image(
                image: AssetImage("images/a.png"),
              ),
            ),
          ),
          SizedBox(
            height: 120,
          ),
          Container(

            child: FlatButton(
              onPressed: () => _handleSignIn(),
              child: Image(
                image: AssetImage(
                    "images/gmail_login.png"
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
