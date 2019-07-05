import 'package:flutter/material.dart';
import 'package:squadre/Model/UserModel.dart';
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstants;
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/widgets/PinderyCircleAvatar.dart';
import 'package:squadre/widgets/video_player/aspect_ratio_video.dart';
import 'package:squadre/widgets/video_player/network_player_lifecycle.dart';
import 'package:video_player/video_player.dart';

class PostItem extends StatefulWidget {
  Map data;

  PostItem(this.data);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
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
    return Container(
      width: Utils.deviceWidth,
      margin: EdgeInsets.all(10),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PinderyCircleAvatar(user: _user, radius: 16),
                  ),
                  Text((_user == null) ? "" : _user.name)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.data['message'] ?? '',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: (widget.data['replies'] != null &&
                        widget.data['replies'].values.last['reply']
                            .toString()
                            .contains('http'))
                    ? Container(
                        child: NetworkPlayerLifeCycle(
                          widget.data['replies'].values.last['reply']
                              .toString(),
                          (BuildContext context,
                                  VideoPlayerController controller) =>
                              OBAspectRatioVideo(controller),
                        ),
                      )
                    : Text(
                        widget.data['replies'] == null
                            ? ''
                            : widget.data['replies'].values.last['reply']
                                .toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
