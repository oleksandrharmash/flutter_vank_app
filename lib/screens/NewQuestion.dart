import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/utils/SharedPref.dart';
import 'package:squadre/utils/Utils.dart';

class NewQuestion extends StatefulWidget {
  @override
  _NewQuestionState createState() => _NewQuestionState();
}

class _NewQuestionState extends State<NewQuestion> {
  TextEditingController controller;
  TextEditingController controller1;
  String posted_time = "";
  int selectIndex = 0;
  List teamList = List();
  Duration initialtimer = new Duration();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller1 = TextEditingController();

    getTeamsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Card(
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: FloatingActionButton(
          backgroundColor: Utils.purpleColor,
          onPressed: () {
            addPost();
          },
          child: Icon(
            Icons.done,
            color: Utils.colorWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              elevation: 0,
              backgroundColor: Utils.pinkColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Utils.colorWhite,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: 60.0,
              width: Utils.deviceWidth,
              color: Utils.pinkColor,
              alignment: Alignment.center,
              child: Text(
                'Su quale squadra vuoi\n farela tua domanda?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150.0,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectIndex == index
                                        ? Utils.blueColor
                                        : Utils.greyColor,
                                    width: 3.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectIndex = index;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                          image: AdvancedNetworkImage(
                                            teamList[index]
                                                [AppConstant.TEAM_IMAGE],
                                            scale: 0.2,
                                            useDiskCache: true,
                                          ),
                                          fit: BoxFit.scaleDown,
                                          height: 100,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          teamList[index]
                                              [AppConstant.TEAM_NAME],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            elevation: 20.0,
                            shadowColor: Utils.blueShadowColor,
                          ),
                        ),
                        /* FractionalTranslation(
                            translation: Offset(0.0, -0.5),
                            child: Container(
                                height: 5,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Utils
                                        .transparentColor // I played with different colors code for get transparency of color but Alway display White.
                                    )))*/
                      ],
                    ),
                  );
                },
                itemCount: teamList.length,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 50),
              height: 320.0,
              width: Utils.deviceWidth - 20,
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                elevation: 20.0,
                color: Colors.white,
                shadowColor: Utils.blueShadowColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Scrivi la tua domanda…',
                      contentPadding: EdgeInsets.only(left: 15, top: 15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

//code by gaurav singh
  getUid() async {
    String uid = await SharedPref().readStringValue("uid");
    if (uid.isNotEmpty) {
      //get timestamp of last posted question by particular user id
      fbUtils.getPosts().then((db) {
        db
            .orderByChild("postUserId")
            .equalTo(uid)
            .limitToLast(1)
            .once()
            .then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            final posted_date = DateTime.fromMillisecondsSinceEpoch(
                values.values.toList()[0]["time"]);
            print(posted_date);
            //1 hour diff before asking another question
            final after24hrsdate = posted_date.add(Duration(hours: 1));
            print(after24hrsdate);

            //get current time
            final date2 = DateTime.now();

            //find number of hours between previous question time and current time
            final difference = after24hrsdate.difference(date2).inSeconds;
            print(difference);
            //to post new question if current time and previous question time differs by 1 hour add question otherwise it will show message
            if (difference >= 3600 || difference < 0) {
              print(teamList[selectIndex][AppConstant.TEAM_ID]);
              addQuestion();
            } else {
              Fluttertoast.showToast(
                  msg: "You cannot post another question before 1 hour",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }else{
            addQuestion();
          }
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

  void addQuestion() {
    //adds new question in firebase database
    fbUtils
        .addPost(initialtimer.inSeconds, controller.text,
            teamList[selectIndex][AppConstant.TEAM_ID])
        .then((b) {
      if (b == true) {
        SharedPref().setStringShared("current_time", DateTime.now().toString());
        Utils.showMessage("Question Posted");
        setState(() {
          controller.text = "";
        });
        Utils.refresh.add(true);
        Navigator.pop(context);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void addPost() {
    print(DateTime.now());

    //code by gaurav singh
    getUid();
  }

  void getTeamsList() {
    fbUtils.getTeams().then((db) {
      db.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;

        if (values != null) {
          teamList = List();
          values.forEach((key, values) {
            teamList.add(values);
          });

          print('--${teamList.length}');
          setState(() {});
        }
      });
    }).catchError((error) {
      print(error);
    });
  }
}
