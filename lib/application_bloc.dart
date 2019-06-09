import 'dart:async';
import 'package:rail_lens/validator.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';
import 'models/model.dart';
import 'network.dart';

class ApplicationBloc extends BaseBloc {
  //TODO: Replace Object with appropriate type
  final _databaseStreamController = StreamController<Object>();
  final RailApi _railApi = RailApi();

  //TODO: Replace with actual database call
  Stream<Credentials> get credentialStream => Observable.timer(
      Credentials("some random", "value lol"), Duration(milliseconds: 10));
  Stream<bool> get isLoggedIn => credentialStream.map((credentials) {
        if (credentials.username == 'some random' &&
            credentials.password == 'value lol') return false;
        return true;
      });

  ApplicationBloc() {
    //Setup the database stream, so that isLoggedIn can return actual credentials
  }

  @override
  void dispose() {
    print('Disposing Application Bloc');
    _databaseStreamController.close();
  }
}

class LoginBloc extends BaseBloc with Validator {
  final _usernameController = PublishSubject<String>();
  final _passwordController = PublishSubject<String>();
//  var _authorizationStream = Stream.empty();

  final RailApi api = RailApi();

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

  Stream<AuthorizationModel> get authorizationStream => _userPassStream
      .where((list)=>list[2])
//      .asyncMap((pair)=>api.login(pair[0], pair[1]));
          .map((dummy) {
        //TODO: Remove dummy data from here
        return new AuthorizationModel(true, true, ['DEL']);
      });

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

  final RailApi _api = RailApi();

  Stream<String> get newPassword =>
      _newPasswordController.stream.transform(passwordValidator);
  Stream<bool> get confirmPassword =>
      Observable.combineLatest2(newPassword, _confirmPasswordController.stream,
          (newPass, confPass) {
        if (newPass != confPass)
          throw Exception('Passwords do not match');
        else
          return true;
      });

  @override
  void dispose() {
    print('Disposing ChangePassword Bloc');
    _oldPasswordController.close();
    _newPasswordController.close();
    _confirmPasswordController.close();
  }
}
