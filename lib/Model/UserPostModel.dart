import 'package:squadre/utils/AppConstant.dart' as AppConstants;
import 'package:firebase_database/firebase_database.dart';

class UserPostModel{

  ServerValue _time;
  String _message;

  UserPostModel(this._time, this._message);

  String get message => _message;

  ServerValue get time => _time;

  UserPostModel.map(dynamic obj) {
    this._time = obj['time'];
    this._message=obj['message'];
  }

  UserPostModel.fromSnapshot(DataSnapshot snapshot) {
    //  this._time=snapshot.value[AppConstants.TIME];
   // this._message=snapshot.value['message'];

   /* print("time");
    print(snapshot.value);
    print("message");
    print(_message);
*/
  }

}