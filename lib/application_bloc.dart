import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rail_lens/validator.dart';
import 'consta.dart';
import 'bloc_provider.dart';
import 'models/model.dart';
import 'network.dart';

class ApplicationBloc extends BaseBloc {
  //TODO: Use database if not using sharedpreferences
//  final _databaseStreamController = StreamController<Object>();
  final RailApi _railApi = RailApi();

  //WorkAround until db integration
  String _cachedUsername;
  String _cachedPassword;
  List<Station> _cachedStationList;

  List<Station> get cachedStationList => _cachedStationList;
  //TODO: Replace with actual database call
  Stream<Credentials> get credentialStream =>
      Observable.fromFuture(getCredentials());

  Stream<AuthorizationModel> get isLoggedIn =>
      credentialStream.asyncMap((credentials) {
        print('Getting credentials!');
        if (credentials?.username != null && credentials?.password != null) {
          print('Found Credentials!');
          print('They are ${credentials.username} && ${credentials.password}');
          if (Validator.usernameConditionChecker(credentials.username) &&
              Validator.passwordConditionChecker(credentials.password)) {
            return _railApi.login(credentials.username, credentials.password);
          }
          print('Invalid stored credentials');
          return Future.error(
              'Stored credentials were invalid! Please login again');
        }
        print('No credentials stored');
        return Future.value(AuthorizationModel(false, false, null));
      });

  Future<void> storeCredentials(String username, String password) async {
    print('Storing credentials');
    _cachedUsername = username;
    _cachedPassword = password;
    //TODO: Save credentials in base64(use plain text until login and change password are converted)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(consta.userKey, username);
    await prefs.setString(consta.passKey, password);
  }

  Future<Credentials> getCredentials() async {
    print('getting credentials');
    if (!(_cachedUsername?.isNotEmpty == true) &&
        !(_cachedPassword?.isEmpty == true)) {
      print('first time loading');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString(consta.userKey);
      String pass = prefs.getString(consta.passKey);
      _cachedUsername = user;
      _cachedPassword = pass;
    }
    print('Already cached! u is $_cachedUsername and p is $_cachedPassword');
    return Credentials(_cachedUsername, _cachedPassword);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(consta.userKey, null);
    await prefs.setString(consta.passKey, null);
  }

  void storeStationList(List<Station> list) {
    _cachedStationList = list;
  }

  Future<void> storeUsername(String username) async {
    _cachedUsername = username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(consta.userKey, username);
  }

  Future<void> storePassword(String password) async {
    _cachedPassword = password;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(consta.passKey, password);
  }

  ApplicationBloc() {
    //TODO:Complete
    //Setup the database stream, so that isLoggedIn can return actual credentials
  }

  @override
  void dispose() {
    print('Disposing Application Bloc');
//    _databaseStreamController.close();
  }
}

class LoginBloc extends BaseBloc with Validator {
  final _usernameController = PublishSubject<String>();
  final _passwordController = PublishSubject<String>();
  String _lastUsername = '';
  String _lastPassword = '';

  final RailApi _api = RailApi();

  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  //TODO: Yes this is ugly, please change
  Stream<List<Object>> get _userPassStream =>
      Observable.zip2(_usernameController.stream, _passwordController.stream,
          (u, p) {
        print('$u and $p were submitted');
        return [
          u,
          p,
          Validator.usernameConditionChecker(u) &&
              Validator.passwordConditionChecker(p)
        ];
      });

  Stream<bool> get submitCheck => _userPassStream.map((data) => data[2]);

  Stream<AuthorizationModel> get authorizationStream =>
      Observable(_userPassStream.where((list) => list[2])).doOnData((dataList) {
        _lastPassword = dataList[1];
        _lastUsername = dataList[0];
      }).asyncMap((pair) => _api.login(pair[0], pair[1]));
//          .map((dummy) {
//        //TODO: Remove dummy data from here
//        return new AuthorizationModel(true, true, ['DEL']);
//      });

  String get lastUsername => _lastUsername;
  String get lastPassword => _lastPassword;

  Function(String) get usernameChanged => _usernameController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
  }
}

class ChangePasswordBloc extends BaseBloc with Validator {
  final _newPasswordController = PublishSubject<String>();
  final _confirmPasswordController = PublishSubject<String>();
  final _oldPasswordController = PublishSubject<String>();

  String _lastPassword = '';
  final RailApi _api = RailApi();

  Stream<String> get newPassword =>
      _newPasswordController.stream.transform(passwordValidator);
  Stream<List<Object>> get confirmPassword => Observable.zip3(
          _newPasswordController.stream,
          _confirmPasswordController.stream,
          _oldPasswordController.stream, (newPass, confPass, oldPass) {
        print('given passes are $oldPass, $newPass, $confPass');
        return [oldPass, newPass, confPass];
      }).transform(confPassValidator);

  //TODO: Change so that it accesses username saved from the database
  String _username = 'a';
  Stream<bool> get validEntries =>
      confirmPassword.map((list) => list[list.length - 1]);

  Stream<AuthorizationModel> get authorizationStream =>
      confirmPassword.asyncMap<Map<String,String>>((passList) {
        _lastPassword = passList[0];
        var credMap = Map<String, String>();
        credMap['username'] = _username;
        credMap['oldpass'] = passList[0];
        credMap['newpass'] = passList[1];
        print('Sending this parameter map -> $credMap');
        return credMap;
      }).asyncMap<AuthorizationModel>((credMap) {
        return _api.changePassword(credMap['username'], credMap['oldpass'], credMap['newpass']);
      });

  String get lastPassword => _lastPassword;

  Function(String) get oldPassChanged => _oldPasswordController.sink.add;
  Function(String) get newPassChanged => _newPasswordController.sink.add;
  Function(String) get confirmPassChanged =>
      _confirmPasswordController.sink.add;

  @override
  void dispose() {
    print('Disposing ChangePassword Bloc');
    _oldPasswordController.close();
    _newPasswordController.close();
    _confirmPasswordController.close();
  }
}

class UploadBloc extends BaseBloc {
  final RailApi _api = RailApi();

  @override
  void dispose() {}
}
