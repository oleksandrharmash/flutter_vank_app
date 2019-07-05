import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:squadre/Model/UserPostModel.dart';
import 'package:squadre/screens/ChatPage.dart';
import 'package:squadre/screens/FeedPage.dart';
import 'package:squadre/screens/NewQuestion.dart';
import 'package:squadre/screens/Profile.dart';
import 'package:squadre/screens/TeamSelection.dart';
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/widgets/PostItem.dart';
import 'package:squadre/utils/Firebase.dart' as fbUtils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;
  List<UserPostModel> postData;


  @override
  void initState() {
    postData=List();
    getVal();
  }


  void getVal(){

    /*
    fbUtils.getPosts(Utils.userUid).then((noteReference){

      print("noteRef");
      print(noteReference);

 //     _onNoteAddedSubscription = noteReference.onChildAdded.listen(posts);

    }).catchError((error){
      print(error);
    });
    */
  }
  void posts(Event event) {
    setState(() {
      postData.add(new UserPostModel.fromSnapshot(event.snapshot));
      print("event values");
      print(event.snapshot.value);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 20.0),
              blurRadius: 40.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    page = 0;
                  });
                }),
            IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  setState(() {
                    page = 1;
                  });
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.purpleColor,
        elevation: 20,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewQuestion()));
        },
        child: Icon(
          Icons.add,
          color: Utils.colorWhite,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: getWidget(context),
    );
  }

  Widget getWidget(BuildContext context) {
    switch (page) {
      case 0:
        return FeedPage();
        break;

      case 1:
        return Profile();
    }

    return Container();
  }
}
