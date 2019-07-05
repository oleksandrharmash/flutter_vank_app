import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:squadre/Model/UserModel.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstants;
import 'package:squadre/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> login(String emails, String passwords) async {
  try {
    final firebaseUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emails, password: passwords);
    Utils.registerModel.uuid = firebaseUser.uid;

    return firebaseUser.uid;
  } catch (e) {
    throw (e);
  }
}

Future<DatabaseReference> getProfile(String uid) async {
  try {
    final notesReference = await FirebaseDatabase.instance
        .reference()
        .child(AppConstants.USER)
        .child(uid);

    return notesReference;
  } catch (e) {
    throw (e);
  }
}

Future<bool> register(String email, String pass, String name) async {
  try {
    final firebaseAuth = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);
    firebaseAuth.sendEmailVerification();

    userDetails(firebaseAuth.uid, name, pass, email);

    return true;
  } catch (e) {
    throw (e);
  }
}

void userDetails(String uuid, String username, String password, String email) {
  final noteRef =
      FirebaseDatabase.instance.reference().child(AppConstants.USER);

  noteRef.child(uuid).update({
    AppConstants.NAME: username,
    AppConstants.EMAIL: email,
    AppConstants.PASSWORD: password,
    AppConstants.ISADMIN: Utils.registerModel.isAdmin,
  }).then((_) {});
}

Future<bool> addPost(int time, String msg, int teamId) async {
  final fbPots = await FirebaseDatabase.instance
      .reference()
      .child(AppConstants.POST)
      .push();

  try {
    fbPots.set({
      "questionvalidtime": time,
      AppConstants.TIME: ServerValue.timestamp,
      AppConstants.TEAMID: teamId,
      AppConstants.MESSAGE: msg,
      AppConstants.POST_USER_ID: Utils.registerModel.uuid
    }).then((_) {});
    return true;
  } catch (e) {
    throw (e);
  }
}

Future<bool> addPostReply(
    String reply, bool isAdmin, String userId, String postID, bool isVideo) async {
  final fbPots = await FirebaseDatabase.instance
      .reference()
      .child(AppConstants.POST)
      .child(postID)
      .child("replies")
      .push();

  try {
    fbPots.set({
      AppConstants.TIME: ServerValue.timestamp,
      AppConstants.ISADMIN: isAdmin,
      AppConstants.POST_REPLY: reply,
      AppConstants.POST_USER_ID: userId,
      AppConstants.POST_IS_VIDEO: isVideo

    }).then((_) {
      setIsPostReply(postID);
    });
    return true;
  } catch (e) {
    throw (e);
  }
}

Future<bool> setIsPostReply(String postID) async {
  final fbPots = await FirebaseDatabase.instance
      .reference()
      .child(AppConstants.POST)
      .child(postID);

  try {
    fbPots.update({
      AppConstants.POST_IS_REPLY: true,
    }).then((_) {});
    return true;
  } catch (e) {
    throw (e);
  }
}

Future<bool> setTeam(var url, var name, var id) async {
SharedPreferences.getInstance().then((value){
  getProfile(value.get("uid")).then((data){
    data.once().then((snap) async {
      var finalMap = Map<String, dynamic>.from(snap.value);
      finalMap["favoriteTeam"] = url;
      finalMap["favoriteTeamName"] = name;
      finalMap["favoriteTeamId"] = id;
      Utils.registerModel.favoriteTeamId = id;
      Utils.registerModel.favoriteTeamName = name;
      Utils.registerModel.favoriteTeam = url;


      print("data is "+ finalMap.toString());
      if(finalMap.length != 0){
        await FirebaseDatabase.instance.reference().child("users").child(value.get("uid")).update(finalMap).then((_){
        return true;
      });
      }
    });

  });
}).catchError((e){
  return e;
});
//  getProfile();
}

Future<DatabaseReference> getPosts() async {
  try {
    DatabaseReference notesReference =
        await FirebaseDatabase.instance.reference().child(AppConstants.POST);
    return notesReference;
  } catch (e) {
    throw (e);
  }
}

Future<DatabaseReference> getPostsByUserId(String uid) async {
  try {
    print("getPostsByUserId:" + uid);

    DatabaseReference notesReference = await FirebaseDatabase.instance
        .reference()
        .child(AppConstants.POST)
        .child(uid);
    return notesReference;
  } catch (e) {
    throw (e);
  }
}

Future<DatabaseReference> getReplies(String postId) async {
  print(postId);
  try {
    DatabaseReference notesReference = await FirebaseDatabase.instance
        .reference()
        .child(AppConstants.POST)
        .child(postId);
    print(notesReference.path);
    return notesReference;
  } catch (e) {
    throw (e);
  }
}

Future<DatabaseReference> getTeams() async {
  try {
    DatabaseReference notesReference =
        await FirebaseDatabase.instance.reference().child(AppConstants.TEAMS);
    return notesReference;
  } catch (e) {
    throw (e);
  }
}
