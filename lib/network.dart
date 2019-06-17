import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'models/model.dart';

//Singleton for receiving services
class RailApi {
  final Client _client = Client();
  static const String _url =
      "http://samvad.cris.org.in/stationimages/rest/stationimages/";
  static const String _login = 'login';
  static const String _changePassword = 'changepassword';
  static const String _upload = 'uploadimage';
  static const String _downloadImageList = 'stnimages';

  static const Duration _timeOutWaitMilliSeconds = Duration(milliseconds: 2000);
  static final RailApi _railApi = RailApi._internal();

  factory RailApi() {
    return _railApi;
  }

  RailApi._internal();

  //TODO: Beware of string interpolation
  Future<AuthorizationModel> login(String username, String password) async {
    print('Login Basic: ${base64.encode(utf8.encode('$username:$password'))}');
    AuthorizationModel authorizationModel = await _client
        .post(Uri.parse(_url + _login),
        headers: {
          'accept': 'application/json',
          'Content-type': 'application/x-www-form-urlencoded',
          'Authorization':
          'Basic ${base64.encode(utf8.encode('$username:$password'))}',
        },
        //TODO: Fix possible security error
        body: 'name=' + username + '&password=' + password)
        .timeout(_timeOutWaitMilliSeconds)
        .then((response) => response.body)
        .then((body) {
      print('RESPONSE BODY ALERT! $body');
      return body;
    })
        .then(json.decode)
        .then((json) => AuthorizationModel.fromJson(json));
    return authorizationModel;
  }

  Future<AuthorizationModel> changePassword(
      String username, String oldPassword, String newPassword) async {
    print(
        'Change pass Basic: ${base64.encode(utf8.encode('$username:$oldPassword'))}');
    AuthorizationModel authorizationModel = await _client
        .post(Uri.parse(_url + _changePassword),
        headers: {
          'accept': 'application/json',
          'Content-type': 'application/x-www-form-urlencoded',
          'Authorization':
          'Basic ${base64.encode(utf8.encode('$username:$oldPassword'))}',
        },
        //TODO: Fix possible security error
        body:
        'name=$username&password=$oldPassword&newpassword=$newPassword')
        .timeout(_timeOutWaitMilliSeconds)
        .then((response) => response.body)
        .then((body) {
      print('RESPONSE BODY ALERT! $body');
      return body;
    })
        .then(json.decode)
        .then((json) => AuthorizationModel.fromJson(json));
    return authorizationModel;
  }

  void _basicAuthLowLevelImpl() {
    var url = "http://lol.lol";
    var client = new Client();
    var request = new Request('POST', Uri.parse(url));
    var body = {
      'key': 'value',
    };

    request.headers['authorization'] = 'Basic 021215421fbe4b0d27f:e74b71bbce';
    request.bodyFields = body;
    var future = client
        .send(request)
        .then((response) => response.stream
        .bytesToString()
        .then((value) => print(value.toString())))
        .catchError((error) => print(error.toString()));
  }

  Future<ImageList> fetchImageList(
      String locid, String subinitid, Credentials creds) async {
    print('Fetch Image list Basic:' +
        '${base64.encode(utf8.encode('${creds.username}:${creds.password}'))}');
    ImageList imageList = await _client
        .get(Uri.parse(_url + _downloadImageList+'/$locid/$subinitid'),
      headers: {
        'accept': 'application/json',
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization':
        'Basic ${base64.encode(utf8.encode('${creds.username}:${creds.password}'))}',
      },)
        .timeout(_timeOutWaitMilliSeconds)
        .then((response) => response.body)
        .then((body) {
      print('RESPONSE BODY ALERT! $body');
      return body;
    })
        .then(json.decode)
        .then((json) => ImageList.fromJson(json));
    return imageList;
  }

  Future<bool> uploadImage(int stationCode, int imageId, Credentials cr) async {
    return Future<bool>(() => true);
  }
}
