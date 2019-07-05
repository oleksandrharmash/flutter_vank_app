import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squadre/Model/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:squadre/utils/Translation.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;
import 'package:rxdart/rxdart.dart';

import 'API.dart';
import 'SharedPref.dart';

class Utils {
  static UserModel registerModel = UserModel();
  static API api = API();
  static SharedPref sharedPref = SharedPref();

  static var refresh = new BehaviorSubject<bool>();

  static material.Color greyColor = material.Color(0xFFababaf);
  static material.Color colorHint = material.Color(0xFFababaf);

  static material.Color textColor = material.Color(0xFF212121);
  static Color transparentColor = Color.fromRGBO(189, 189, 189, 1.0);
  static material.Color colorWhite = material.Color(0xFFffffff);
  static material.Color blackColor = material.Color(0xFF000000);
  static material.Color colorOrange = material.Color(0xFFff5419);
  static material.Color buttonColor = material.Color(0xFFfe7865);
  static material.Color blueColor = material.Color(0xFFf3964eb);
  static material.Color blueShadowColor = material.Color(0x95f3964eb);
  static material.Color cardColor = material.Color(0xFFf9faff);
  static material.Color purpleColor = material.Color(0xFF243b6b);
  static material.Color pinkColor = material.Color(0xFFF86C68);
  static material.Color pinkColor2 = material.Color(0xFFFE5295);
  static Color colorAppBar = Color(0xFFF0F0F0);
  static material.Gradient gradient = LinearGradient(
      colors: [Utils.pinkColor, Utils.pinkColor2],
      begin: const FractionalOffset(0.1, 0.1),
      end: const FractionalOffset(3.0, -0.5),
      stops: [0.0, 0.4],
      tileMode: TileMode.clamp);

  static double deviceHeight = 0.0;
  static double deviceWidth = 0.0;

  static material.MaterialColor primaryColor =
      const material.MaterialColor(0xFF29C0D4, const {
    50: const material.Color(0xFF29C0D4),
    100: const material.Color(0xFF29C0D4),
    200: const material.Color(0xFF29C0D4),
    300: const material.Color(0xFF29C0D4),
    400: const material.Color(0xFF29C0D4),
    500: const material.Color(0xFF29C0D4),
    600: const material.Color(0xFF29C0D4),
    700: const material.Color(0xFF29C0D4),
    800: const material.Color(0xFF29C0D4),
    900: const material.Color(0xFF1D8997)
  });

  static void showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        fontSize: 15,
        backgroundColor: blackColor,
        gravity: ToastGravity.BOTTOM,
        textColor: colorWhite,
        toastLength: Toast.LENGTH_LONG);
  }

  static String getTranslation(String text) {
    return localizedValues['en'][text];
  }

  static String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('h:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  static void saveUserData() {
    Utils.sharedPref
        .setStringShared(AppConstant.USER_ID, Utils.registerModel.uuid);
    Utils.sharedPref
        .setStringShared(AppConstant.NAME, Utils.registerModel.name);
    Utils.sharedPref
        .setBoolShared(AppConstant.ISADMIN, Utils.registerModel.isAdmin);

    Utils.sharedPref
        .setStringShared(AppConstant.EMAIL, Utils.registerModel.email);

    Utils.sharedPref.setStringShared(
        AppConstant.FAVORITE_TEAM, Utils.registerModel.favoriteTeam);

    Utils.sharedPref.setIntShared(
        AppConstant.FAVORITE_TEAM_ID, Utils.registerModel.favoriteTeamId);

    Utils.sharedPref.setStringShared(
        AppConstant.FAVORITE_TEAM_NAME, Utils.registerModel.favoriteTeamName);

    Utils.sharedPref.setStringShared(
        AppConstant.AVATAR, Utils.registerModel.avatar);
  }

  static Future<void> readUserData() async {
    Utils.registerModel.uuid =
        await Utils.sharedPref.getData(AppConstant.USER_ID);

    Utils.registerModel.avatar =
    await Utils.sharedPref.getData(AppConstant.AVATAR);

    Utils.registerModel.name =
        await Utils.sharedPref.getData(AppConstant.NAME);

    Utils.registerModel.isAdmin =
        await Utils.sharedPref.getData(AppConstant.ISADMIN);

    Utils.registerModel.email =
        await Utils.sharedPref.getData(AppConstant.EMAIL);

    Utils.registerModel.favoriteTeamId =
        await Utils.sharedPref.getData(AppConstant.FAVORITE_TEAM_ID);

    Utils.registerModel.favoriteTeamName =
        await Utils.sharedPref.getData(AppConstant.FAVORITE_TEAM_NAME);

    Utils.registerModel.favoriteTeam =
        await Utils.sharedPref.getData(AppConstant.FAVORITE_TEAM);

    print(Utils.registerModel.uuid);
    print(Utils.registerModel.name);
    print(Utils.registerModel.isAdmin);
    print(Utils.registerModel.email);
    print(Utils.registerModel.avatar);
    print(Utils.registerModel.favoriteTeamName);
    print(Utils.registerModel.favoriteTeamId);
    print(Utils.registerModel.favoriteTeam);
  }
}
