/// Some utils for the app
///

// External libraries imports
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:squadre/Model/UserModel.dart';
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/utils/AppConstant.dart' as AppConstants;

/// A [CircleAvatar] which checks whether the user has a profile picture or not
/// Actually if the user has a picture, it's not a [CircleAvatar], but a
/// [MaterialType.circle], so that the image can be cached with a [CachedNetworkImage].
/// There is also the user's initial as placeholder while downloading and in case of error.
class PinderyCircleAvatar extends StatelessWidget {
  PinderyCircleAvatar({this.user, this.radius = 72.0});

  /// The [User] whose image/name is used for the widget
  final UserModel user;

  /// The the radius of the circle
  final double radius;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: radius*2,
      width: radius*2,
      child: new ClipOval(
        child:
            new CachedNetworkImage(fit: BoxFit.fill, imageUrl: (user == null || user.avatar == null) ? AppConstants.DEFAULT_AVATAR : user.avatar),
      ),
    );
  }
}

/// A [Widget] that returns a [Center] widget with the initial of the name passed
/// as parameter, to be used with [PinderyCircleAvatar].
class UserInitialWidget extends StatelessWidget {
  UserInitialWidget({this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(
        name[0],
        style: new TextStyle(color: Colors.white, fontSize: 30.0),
      ),
    );
  }
}
