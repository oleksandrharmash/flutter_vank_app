import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Utils.dart';

class API {
  Future<bool> facebookInfo() async {



    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email', 'public_profile']);


    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        final _auth = await FirebaseAuth.instance;
        FacebookAccessToken myToken = result.accessToken;

        AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: myToken.token);

        FirebaseUser firebaseUser = await _auth.signInWithCredential(credential);

        Utils.registerModel.txtFieldValue = false;
        Utils.registerModel.source = "facebook";
        Utils.registerModel.email = firebaseUser.email;
    //    Utils.registerModel.googleToken = firebaseUser.idToken;
        Utils.registerModel.name = firebaseUser.displayName;
        Utils.registerModel.uuid = firebaseUser.uid;



        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.error:
        Utils.showMessage(FacebookLoginStatus.error.toString());
        print("Error12345");
        print(result.errorMessage);
        break;
    }
    return true;
  }

/*  Future<bool> loginWithGoogle(String googleToken) async {
    print("google token is  ");
    print(googleToken);
    Utils.sharedPref.setToken(googleToken);
    try {
      Response response = await Dio()
          .post(SIGNIN, data: json.encode({"google_token": googleToken}));
      print("data is");
      print(response.data);
      if (response.data != null) {
        return true;
      }
    } catch (e) {
      DioError a = e;
      Map map = a.response.data;
      print(map);
      String message = map[AppConstants.MESSAGE];
      Utils.showMessage(message);
      print(a.response.data);
      throw (e);
    }
  }*/


  Future<bool> googleInfo() async {
    print("error");


    try {
      final _auth = await FirebaseAuth.instance;

      print("autttthhhh");

      GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credential);

      print(user.email);

      Utils.registerModel.txtFieldValue = false;
      Utils.registerModel.source = "google";
      Utils.registerModel.email = user.email;
      Utils.registerModel.googleToken = googleAuth.idToken;
      Utils.registerModel.name = user.displayName;
      final FirebaseUser currentUser = await _auth.currentUser();


      Utils.registerModel.uuid = currentUser.uid;

      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user ${Utils.registerModel.uuid}');
      print(user.email);


      print("google signed in user: ${user?.email}");
    } catch (error) {
      print("google sign in error: $error"); // error is printed here
          }



    return true;
  }
}
