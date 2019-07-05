import 'package:shared_preferences/shared_preferences.dart';
import 'AppConstant.dart' as AppConstant;

class SharedPref {
  SharedPreferences sharedPreferences;

  void setToken(String token) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(AppConstant.USERTOKEN, token);
  }

  Future<String> getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get(AppConstant.USERTOKEN);

    return token;
  }

  //added by gaurav singh
  Future<String> readStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  Future<dynamic> getData(String key) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  void setStringShared(String key, String data) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, data);
  }

  void setBoolShared(String key, bool data) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, data);
  }

  void setIntShared(String key, int data) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(key, data);
  }
}
