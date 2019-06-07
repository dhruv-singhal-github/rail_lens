import 'dart:async';
import 'package:rail_lens/validator.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';
import 'models/model.dart';
import 'network.dart';


class LoginBloc extends Object with Validator implements BaseBloc {
  final _usernameController = PublishSubject<String>();
  final _passwordController = PublishSubject<String>();
//  var _authorizationStream = Stream.empty();

  final RailApi api;

  LoginBloc(this.api);

  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck =>
      Observable.combineLatest2(username, password, (u, p) {
        print('submit check bish username was $u and password was $p');
        return true;
      });
  Stream<AuthorizationModel> get authorizationStream =>
      Observable.combineLatest2(username, password, (username, password) {
        print('username was $username and password was $password');
        return [username, password];
//      }).asyncMap((pair)=>api.login(pair[0], pair[1]));
      }).map((dummy){
        return new AuthorizationModel(true, false, ['DEL']);
      });

  Function(String) get usernameChanged => _usernameController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
//    _authorizationController.close();
  }

}