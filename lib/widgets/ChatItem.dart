import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squadre/Model/UserModel.dart';
import 'package:squadre/screens/ChatPage.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstants;
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/widgets/PinderyCircleAvatar.dart';
import 'package:squadre/utils/Firebase.dart' as fbUtils;

class ChatItem extends StatefulWidget {
  Map data;

  ChatItem(this.data);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  UserModel _user;

  @override
  void initState() {
    super.initState();

    getProfileData();
  }

  void getProfileData() {
    fbUtils.getProfile(widget.data['postUserId']).then((noteReference) {
      noteReference.once().then((snap) async {
        Map map = snap.value;
        print('---$map');

        if (map != null) {
          UserModel user = new UserModel();
          user.isAdmin = map[AppConstants.ISADMIN];
          user.name = map[AppConstants.NAME];
          user.email = map[AppConstants.EMAIL];
          user.favoriteTeam = map[AppConstants.FAVORITE_TEAM];
          user.favoriteTeamName = map[AppConstants.FAVORITE_TEAM_NAME];
          user.favoriteTeamId = map[AppConstants.FAVORITE_TEAM_ID];
          user.avatar = map[AppConstants.AVATAR];
          setState(() {
            _user = user;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget?.data.toString());
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatPage(widget.data)));
          },
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: new PinderyCircleAvatar(user: _user, radius: 20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text(_user?.name ?? " ")),
                Text(
                  DateFormat.jm().format(
                      DateTime.fromMillisecondsSinceEpoch(widget.data["time"])),
                  style: TextStyle(fontSize: 14.0, color: Utils.greyColor),
                )
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.data['message'].toString(),
                      style: TextStyle(color: Utils.greyColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Utils.greyColor,
                    size: 15,
                  )
                ],
              ),
            ),
//            trailing: Icon(
//              Icons.arrow_forward_ios,
//              color: Utils.greyColor,
//              size: 20,
//            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
