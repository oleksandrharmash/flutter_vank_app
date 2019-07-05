import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:squadre/screens/Login.dart';
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;
import 'dart:async';

import 'ChatListPage.dart';
import 'HomePage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Utils.deviceWidth = MediaQuery.of(context).size.width;
    Utils.deviceHeight = MediaQuery.of(context).size.height;

    Timer(Duration(seconds: 2), () async {
      final _auth = await FirebaseAuth.instance;
      final FirebaseUser currentUser = await _auth.currentUser();

      Utils.readUserData().then((v){

        if (Utils.registerModel.email == null || currentUser == null || currentUser.email == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else if (Utils.registerModel.isAdmin ) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatListPage()));
        }
        else
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
      });

    });

    /* final noteRef = FirebaseDatabase.instance
          .reference()
          .child("posts/-LdIw6gKovOtMhvZ4f05/replies");

      noteRef.push().set({
        "postUserId": 'CT8yF6X78EcmXsoLybrobgBQRdL2',
        "reply": "You will get T shirt",
        AppConstant.TIME: ServerValue.timestamp,
      }).then((_) {});*/

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Align(
            alignment: Alignment(0.0, 2.5),
            child: Container(
              width: Utils.deviceWidth,
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Image.asset('assets/images/football.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Demande\nrisposte",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 45, color: Utils.buttonColor),
                  ),
                ),

                /* Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Fai la tua domanda sul calcio avrai la tua risposta da un esperto in meno di 24 ore",
                      style: TextStyle(color: Utils.greyColor),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Inizia",
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
