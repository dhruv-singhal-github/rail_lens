import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'models/model.dart';

class RailApi {
  final Client _client = Client();
  static const String _url = '172.16.XXX.XXX/raillens/';
  static const String _login = 'login';
  static const String _changePassword = 'changePassword';

  Future<AuthorizationModel> login(String username, String password) async {
    AuthorizationModel authorizationModel = await _client
        .post(Uri.parse(_url + _login),
            headers: {'Content-type': 'application/json'},
            body: json.encoder
                .convert({'username': username, 'password': password}))
        .then((response) => response.body)
        .then(json.decode)
        .then((json) => AuthorizationModel.fromJson(json));
    return authorizationModel;
  }

  Future<bool> changePassword(
      String username, String oldPassword, String newPassword) async {

    return Future<bool>(() => true);
  }

  void _basicAuthLowLevelImpl(){
    var url = "http://lol.lol";
    var client = new Client();
    var request = new Request('POST', Uri.parse(url));
    var body = {'key':'value',};

    request.headers['authorization'] = 'Basic 021215421fbe4b0d27f:e74b71bbce';
    request.bodyFields = body;
    var future = client.send(request).then((response)
    => response.stream.bytesToString().then((value)
    => print(value.toString()))).catchError((error) => print(error.toString()));
  }
}
