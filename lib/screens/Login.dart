import 'package:flutter/material.dart';
import 'package:squadre/screens/Register.dart';
import 'package:squadre/screens/TeamSelection.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstants;
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/utils/SharedPref.dart';
import 'package:squadre/utils/Utils.dart';
import 'ChatListPage.dart';
import 'HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController =
      TextEditingController(text: "luigisag@gmail.com");
  TextEditingController passController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    Utils.deviceWidth = MediaQuery.of(context).size.width;
    Utils.deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: Utils.deviceWidth,
        color: Utils.colorWhite,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image.asset('assets/images/football.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 35),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                        decoration: InputDecoration(
                            hintText: "Inserisci la tua email",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Utils.blackColor, fontSize: 20),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Utils.greyColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid))),
                        controller: nameController,
                        style: TextStyle(fontSize: 23)),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Inserisci la tua password",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Password",
                            labelStyle: TextStyle(
                                color: Utils.blackColor, fontSize: 20),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Utils.greyColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Utils.greyColor))),
                        style: TextStyle(
                          fontSize: 23,
                        ),
                        controller: passController),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Password dimenticata ?",
                        style: TextStyle(color: Utils.greyColor, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                height: 50,
                margin: EdgeInsets.only(bottom: 30, top: 40),
                child: RaisedButton(
                    onPressed: () {
                      login(nameController.text, passController.text);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Utils.colorWhite, fontSize: 20.0),
                    ),
                    color: Utils.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ),
              Text(
                "oppure",
                style: TextStyle(color: Utils.greyColor),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              "assets/images/google.png",
                              scale: 2,
                            ),
                          )),
                      onTap: () {
                        loginViaGoogle();
                      },
                    ),
                    GestureDetector(
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              "assets/images/fb.png",
                              scale: 2,
                            ),
                          )),
                      onTap: () {
                        fbLogin();
                      },
                    ),
                    GestureDetector(
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              "assets/images/twitter.png",
                              scale: 2,
                            ),
                          )),
                      onTap: () {},
                    ),
                    GestureDetector(
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              "assets/images/linked.png",
                              scale: 2,
                            ),
                          )),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Non hai un account ?"),
                      Text(
                        "SignUp",
                        style: TextStyle(color: Utils.blueColor),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void login(String email, String password) {
    fbUtils.login(email, password).then((value) {
      if (value != null) {
        SharedPref().setStringShared("login", "true");
        //code done by gaurav singh
        //set uid in shared preference so that questions posted by this id only will be displayed
        SharedPref().setStringShared("uid", value);
        getProfile(value);

      } else {
        print(Exception);
      }
    }).catchError((error) {
      Utils.showMessage(Utils.getTranslation("invalidUserNPass"));

      print(error);
    });
  }

  void getProfile(String uid) {
    fbUtils.getProfile(uid).then((noteReference) {
      noteReference.once().then((snap) {
        Map map = snap.value;

        print("map is------->>>>" + map.toString());

        if (map != null) {
          Utils.registerModel.isAdmin = map[AppConstants.ISADMIN] ?? false;
          Utils.registerModel.name = map[AppConstants.NAME];
          Utils.registerModel.email = map[AppConstants.EMAIL];
          Utils.registerModel.favoriteTeam = map[AppConstants.FAVORITE_TEAM];
          Utils.registerModel.favoriteTeamName = map[AppConstants.FAVORITE_TEAM_NAME];
          Utils.registerModel.favoriteTeamId = map[AppConstants.FAVORITE_TEAM_ID];
          Utils.registerModel.avatar = map[AppConstants.AVATAR];

          Utils.saveUserData();

          //code written by Pawan

          if (Utils.registerModel.isAdmin == true) {
            Utils.showMessage("Hello Admin");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ChatListPage()));
          } else {
            Utils.showMessage("Welcome user");

            if(map.containsKey("favoriteTeam")){
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
            }
            else{
              Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TeamSelection()));
            }


            //old code

//            Utils.sharedPref.getData(AppConstants.SELECTED_TEAM).then((d) {
//              print('11 ${d}');
//              if (d == null) {
//                Navigator.pushReplacement(context,
//                    MaterialPageRoute(builder: (context) => TeamSelection()));
//              } else {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => HomePage()));
//              }
//            });
          }
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  void loginViaGoogle() {
    try {
      Utils.api.googleInfo().then((b) {
        if (b) {
          fbUtils.getProfile(Utils.registerModel.uuid).then((noteReference) {
            noteReference.once().then((snap) async {
              Map map = snap.value;
              print('---$map');

              if (map != null) {
                Utils.registerModel.isAdmin =
                    map[AppConstants.ISADMIN] ?? false;
                Utils.registerModel.name = map[AppConstants.NAME];
                Utils.registerModel.email = map[AppConstants.EMAIL];
                Utils.registerModel.favoriteTeam = map[AppConstants.FAVORITE_TEAM];
                Utils.registerModel.favoriteTeamName = map[AppConstants.FAVORITE_TEAM_NAME];
                Utils.registerModel.favoriteTeamId = map[AppConstants.FAVORITE_TEAM_ID];
                Utils.registerModel.avatar = map[AppConstants.AVATAR];

                Utils.saveUserData();

                if (Utils.registerModel.isAdmin == true) {
                  Utils.showMessage("Hello Admin");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ChatListPage()));
                } else {
                  Utils.showMessage("Welcome user");

                  Utils.sharedPref
                      .getData(AppConstants.SELECTED_TEAM)
                      .then((d) {
                    if (d == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeamSelection()));
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  });
                }
              } else {
                fbUtils.userDetails(
                    Utils.registerModel.uuid,
                    Utils.registerModel.name,
                    '123456',
                    Utils.registerModel.email);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TeamSelection()));
              }
            });
          }).catchError((error) {
            print(error);
          });
        }
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  void fbLogin() {
    try {
      Utils.api.facebookInfo().then((b) {
        if (b) {
          fbUtils.getProfile(Utils.registerModel.uuid).then((noteReference) {
            noteReference.once().then((snap) async {
              Map map = snap.value;
              print('---$map');

              if (map != null) {
                Utils.registerModel.isAdmin = map[AppConstants.ISADMIN];
                Utils.registerModel.name = map[AppConstants.NAME];
                Utils.registerModel.email = map[AppConstants.EMAIL];
                Utils.registerModel.favoriteTeam = map[AppConstants.FAVORITE_TEAM];
                Utils.registerModel.favoriteTeamName = map[AppConstants.FAVORITE_TEAM_NAME];
                Utils.registerModel.favoriteTeamId = map[AppConstants.FAVORITE_TEAM_ID];
                Utils.registerModel.avatar = map[AppConstants.AVATAR];

                Utils.saveUserData();

                if (Utils.registerModel.isAdmin == true) {
                  Utils.showMessage("Hello Admin");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TeamSelection()));
                } else {
                  Utils.showMessage("Welcome user");

                  Utils.sharedPref
                      .getData(AppConstants.SELECTED_TEAM)
                      .then((d) {
                    if (d == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeamSelection()));
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  });
                }
              } else {
                fbUtils.userDetails(
                    Utils.registerModel.uuid,
                    Utils.registerModel.name,
                    '123456',
                    Utils.registerModel.email);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TeamSelection()));
              }
            });
          }).catchError((error) {
            print(error);
          });
        }
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }
}
