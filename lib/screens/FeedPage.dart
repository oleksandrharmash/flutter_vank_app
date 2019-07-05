import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:squadre/screens/ChatPage.dart';
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;
import 'package:squadre/widgets/PostItem.dart';

import 'TeamSelection.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int page = 0;

  List postList;

  bool isFiltered = false;

  @override
  void initState() {
    super.initState();
    postList = List();
    print('Refresh $postList.lenght');

    getPost();

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
      backgroundColor: Utils.colorWhite,
      appBar: AppBar(
        backgroundColor: Utils.colorWhite,
        elevation: 5,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {},
          child: Text(
            'R I S P O S T E',
            style: TextStyle(
                color: Utils.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
        ),
        actions: <Widget>[
          new Container(
            margin: const EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              border: new Border.all(color: isFiltered? Colors.black : Colors.transparent),
              shape: BoxShape.circle
            ),
            child: GestureDetector(
              onTap: () async {
                isFiltered ? getPost() : getPostByFavoriteTeam();
              },
              child: Image.network(Utils.registerModel.favoriteTeam?? '',
                  height: 30.0, width: 30.0),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20),
        height: Utils.deviceHeight,
        width: Utils.deviceWidth,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              child: PostItem(postList[index]),
              onTap: () {

              },
            );
          },
          itemCount: postList.length,
        ),
      ),
    );
  }

  void getPostByFavoriteTeam() {
    print('post');

    if (postList != null) {
      var postListFavorite = List();
      print('postList $postList');

      postList.forEach((values) {
        print(values['teamId'].toString());

        if (values['teamId'].toString() == Utils.registerModel.favoriteTeamId.toString())
          postListFavorite.add(values);
      });

      print('--${postListFavorite.length}');
      postList = postListFavorite;
      isFiltered = true;
      setState(() {});
    }
  }

  void getPost() {
    print('post');
    fbUtils.getPosts().then((db) {
      db
          .orderByChild("isReplied")
          .equalTo(true)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        print('replies $values');

        if (values != null) {
          postList = List();
          values.forEach((key, values) {
            values[AppConstant.POST_ID] = key;
            postList.add(values);
          });

          print('--${postList.length}');
          isFiltered = false;

          setState(() {});
        }
      });
    }).catchError((error) {
      print(error);
    });
  }
}
