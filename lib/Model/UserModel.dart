class UserModel {
  String uuid;

  String _password, _favoriteTeam, _favoriteTeamName, _avatar,_name;
  bool _isAdmin;
  String googleToken;
  bool txtFieldValue;
  String source;
  String email;
  int _favoriteTeamId;

  UserModel();

  // UserModel(this._username, this._email, this._password,this._isAdmin);

  String get password => _password;
  String get name => _name;
  String get avatar => _avatar;

  String get favoriteTeam => _favoriteTeam;
  int get favoriteTeamId => _favoriteTeamId;
  String get favoriteTeamName => _favoriteTeamName;

  bool get isAdmin => _isAdmin;
  set avatar(String value) => _avatar = value;
  set isAdmin(bool value) => _isAdmin = value;
  set name(String value) => _name = value;
  set favoriteTeam(String value) => _favoriteTeam = value;
  set favoriteTeamId(int value) => _favoriteTeamId = value;
  set favoriteTeamName(String value) => _favoriteTeamName = value;
}
