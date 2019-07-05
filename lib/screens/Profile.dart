import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:squadre/utils/Firebase.dart' as fbUtils;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadre/screens/TeamSelection.dart';
import 'package:squadre/utils/SharedPref.dart';
import 'package:squadre/utils/Utils.dart';
import 'package:countdown/countdown.dart';
import 'SplashScreen.dart';
import 'UpdateProfile.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //code done by gaurav singh
  int _start = 60;
  int _hour = 0;
  int _min = 0;
  Duration initialtimer = new Duration();
  String _str = "00";
  String _str1 = "00";
  String _str2 = "00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //code done by gaurav singh
    getUid();
  }

  //code done by gaurav singh
  void startTimer(int seconds) {
    CountDown cd = CountDown(Duration(seconds: seconds));
    var sub = cd.stream.listen(null);

    sub.onData((Duration d) {
      setState(() {
        _start = d.inSeconds % 60;
        _min = d.inMinutes % 60;
        _hour = d.inHours % 3600;

        _str = _hour.toString();
        _str1 = _min.toString();
        _str2 = _start.toString();
      });
    });

    sub.onDone(() {
      setState(() {
        _str = "00";
        _str1 = "00";
        _str2 = "00";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Utils.colorWhite,
          height: MediaQuery.of(context).size.height-100,
          child: Column(
            children: <Widget>[
              Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(gradient: Utils.gradient),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: FractionalTranslation(
                        translation: Offset(0.0, 0.6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: Utils.colorWhite,
                                ),
                              ),
                              onTap: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();

                                sharedPreferences.clear();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SplashScreen()),
                                    (Route<dynamic> route) => false);
                              },
                            ),
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "P R O F I L O",
                                  style: TextStyle(
                                      color: Utils.colorWhite, fontSize: 17),
                                ),
                              ],
                            )),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: Icon(
                                  Icons.edit,
                                  color: Utils.colorWhite,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateProfile()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionalTranslation(
                        translation: Offset(0, .5),
                        child: FlatButton(
                          onPressed: () {},
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(
                                Utils.registerModel.avatar),
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                ),
                child: Text(
                  Utils.registerModel.name ?? 'username null',
                  style: TextStyle(color: Utils.buttonColor, fontSize: 30),
                ),
              ),
              Text(
                "Biel Bienne, Switzerland",
                style: TextStyle(color: Utils.buttonColor, fontSize: 18),
              ),
              Card(
                elevation: 3,
                color: Color(0xFFf9f9f9),
                margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 25, top: 25),
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("953"),
                            Text(
                              "Domande fatte",
                              style: TextStyle(
                                  color: Utils.greyColor, fontSize: 12),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //code changed by gaurav singh
                            Text(_str +
                                " hours " +
                                _str1 +
                                " min " +
                                _str2 +
                                " seconds"),
                            Text(
                              "Tempo mancante per la prossima domanda",
                              style: TextStyle(
                                  color: Utils.greyColor, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 25, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "La mia squadra del cuore è",
                        style:
                            TextStyle(color: Utils.buttonColor, fontSize: 20),
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamSelection()));
                              },
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      NetworkImage(Utils.registerModel.favoriteTeam),
                                  backgroundColor: Colors.white,
                                ),
                              )),
                          Text(
                            Utils.registerModel.favoriteTeamName,
                            style:
                                TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //code by gaurav singh
  //get userid stored in shared preference
  getUid() async {
    String uid = await SharedPref().readStringValue("uid");
    if (uid.isNotEmpty) {
      fbUtils.getPosts().then((db) {
        db
            .orderByChild("postUserId")
            .equalTo(uid)
            .limitToLast(1)
            .once()
            .then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            //get time of last posted question of particular userid
            final posted_date = DateTime.fromMillisecondsSinceEpoch(
                values.values.toList()[0]["time"]);
            print(posted_date);
            final after24hrsdate = posted_date.add(Duration(hours: 1));
            print(after24hrsdate);

            //get current time
            final date2 = DateTime.now();

            //find number of hours between previous question time an d current time
            final difference = after24hrsdate.difference(date2).inSeconds;
            print(difference);

            //start countdown timer
            startTimer(difference);
          }
        });
      }).catchError((error) {
        print(error);
      });
    }
  }
}
