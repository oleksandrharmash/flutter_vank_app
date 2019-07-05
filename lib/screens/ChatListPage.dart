import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadre/screens/ChatPage.dart';
import 'package:squadre/screens/SplashScreen.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/widgets/ChatItem.dart';
import 'package:squadre/widgets/TeamItems2.dart';

class ChatListPage extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<ChatListPage> {
  List teamList = List();
  List postList;
  List displayList;
  int selectedTeamId = -1;

  @override
  void initState() {
    super.initState();
    postList = List();
    displayList = List();
    getData();
    //tocheck
    Utils.refresh.listen((b) {
      print('Refresh $b');
      if (b ?? false) {
        getPost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Utils.colorWhite,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 50, bottom: 20),
                  child: Text(
                    "Squadre",
                    style: TextStyle(color: Utils.greyColor, fontSize: 16),
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
                );
              }, childCount: 1),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        getPost();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TeamItems2(
                                teamList[index],
                                30,
                                30,
                                count: 1,
                                callback: (b) {
                                  selectTeam(index);
                                },
                              ),
                            );
                          },
                          itemCount: teamList.length,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Divider(
                        height: 1
                      ),
                    )
                  ],
                );
              }, childCount: 1),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Image.asset(
                            'assets/images/people.png',
                            scale: 2
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tutte le chat",
                                hintStyle: TextStyle(color: Colors.grey)),
                            onChanged: (text) {
                              setState(() {
                                displayList = postList.where((post) {
                                  return post[AppConstant.MESSAGE].toString().contains(text);
                                }).toList();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Divider(
                      height: 2,
                      color: Colors.black,
                    )
                  ],
                );
              }, childCount: 1),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                      child: ChatItem(displayList[index]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(null)));
                      });
                },
                childCount: displayList.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectTeam(int index) {
    int teamId = teamList[index][AppConstant.TEAM_ID];
    selectedTeamId = teamId;
    setState(() {
      displayList = getPostByTeam(selectedTeamId);
    });
  }

  getTeamsList() async {
    return fbUtils.getTeams().then((db) {
      return db.once().then((DataSnapshot snapshot) {
        print("get Teams");
        Map<dynamic, dynamic> values = snapshot.value;

        if (values != null) {
          teamList = List();
          values.forEach((key, values) {
            teamList.add(values);
          });
          print('teamLength:${teamList.length}');
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  getPost() async {
    return fbUtils.getPosts().then((db) {
      return db.once().then((DataSnapshot snapshot) {
        print('post');
        Map<dynamic, dynamic> values = snapshot.value;
        print('replies $values');

        if (values != null) {
          postList = List();
          values.forEach((key, values) {
            if (values['replies'] == null) {
              values[AppConstant.POST_ID] = key;
              postList.add(values);
            }
          });
          setState(() {
            displayList = postList;
          });
          print('postLength:${postList.length}');
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  getData() async {
    await getTeamsList();
    await getPost();
    print("getData done");
    if (teamList != null && teamList.length > 0) {
      print("map data");
      teamList.forEach((team) {
        team[AppConstant.POST_NUMBER] =
            getPostByTeam(team[AppConstant.TEAM_ID]).length;
      });
    }
    setState(() {});
  }

  List getPostByTeam(int teamId) {
    if (postList == null || postList.length == 0) {
      return new List();
    } else {
      return postList.where((post) {
        return post[AppConstant.TEAMID] == teamId;
      }).toList();
    }
  }
}