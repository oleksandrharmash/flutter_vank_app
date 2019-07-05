import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/widgets/TeamItems.dart';

import 'HomePage.dart';

class TeamSelection extends StatefulWidget {
  @override
  _TeamSelectionState createState() => _TeamSelectionState();
}

class _TeamSelectionState extends State<TeamSelection> {
  int selectedIndex = 0;

  List teamList = List();

  @override
  void initState() {
    super.initState();

    getTeamsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.colorWhite,
      body: CustomScrollView(

        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                color: Utils.colorWhite,
                margin: EdgeInsets.only(bottom: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text("Quale e la tua\nSquarda del cuore?",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 35, color: Utils.blackColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Per restare sempre informato",
                        style: TextStyle(color: Utils.textColor, fontSize: 18),
                      ),
                    ),
                    Text(
                      "sulla tua squadra. ",
                      style: TextStyle(color: Utils.textColor, fontSize: 18),
                    )
                  ],
                ),
              );
            }, childCount: 1),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 20.0)),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1),
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: TeamItems(
                  teamList[index],
                  isSelected: selectedIndex == index,
                  callback: (b) {
                    selectedIndex = index;

                    Utils.sharedPref
                        .setIntShared(AppConstant.SELECTED_TEAM, selectedIndex);

                    Utils.sharedPref.setStringShared(AppConstant.TEAM_IMAGE,
                        teamList[index][AppConstant.TEAM_IMAGE]);

                    setState(() {});
                  },
                ),
              );
            }, childCount: teamList.length),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 100.0)),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.purpleColor,
        elevation: 20,
        onPressed: () {
          Utils.sharedPref.setStringShared(AppConstant.SELECTED_TEAM,
              teamList[selectedIndex][AppConstant.TEAM_ID].toString());

          fbUtils.setTeam(teamList[selectedIndex]["image"], teamList[selectedIndex]["name"], teamList[selectedIndex]["id"]).then((data){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              (Route<dynamic> route) => false);
          });
        },
        child: Icon(
          Icons.done,
          color: Utils.colorWhite,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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
