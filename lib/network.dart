import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'models/model.dart';

//Singleton for receiving services
class RailApi {
  final Client _client = Client();
  static const String _url =  "http://172.16.21.96:8080/stationimages/rest/stationimages/";
  static const String _login = 'login';
  static const String _changePassword = 'changePassword';
  static const String _upload = 'uploadPics';
  static const String _download = 'downloadThumbnail';

  static final RailApi _railApi = RailApi._internal();

  factory RailApi() {
    return _railApi;
  }

  RailApi._internal();

  Future<AuthorizationModel> login(String username, String password) async {
    AuthorizationModel authorizationModel = await _client
        .post(Uri.parse(_url + _login),
            headers: {
              'accept': 'application/json',
              'Content-type': 'application/x-www-form-urlencoded'
            },
            //TODO: Fix possible security error
            body: 'name=' + username + '&password=' + password)
        .then((response) => response.body)
        .then((body) {
          print('RESPONSE BODY ALERT! + $body');
          return body;
        })
    .then((val){
      if(val == 'true'){
        return "authorization: true, isDefault: false, location_details: [DEL, STD]";
      } else {
        return """"{  
        "employee": {
      "name":       "sonoo",
      "salary":      56000,
      "married":    true
      }
    }  """;
      }
    })
        .then(json.decode)
        .then((json) => AuthorizationModel.fromJson(json));
    return authorizationModel;
  }

  Future<bool> changePassword(
      String username, String oldPassword, String newPassword) async {
    return Future<bool>(() => true);
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

  Future<List<ThumbnailDataModel>> fetchImageList(
      int stationCode, Credentials cr) async {
    return Future<List<ThumbnailDataModel>>(() => [
          ThumbnailDataModel(DateTime.now(), 1, "Image here"),
          ThumbnailDataModel(DateTime.now(), 2, "Image here"),
          ThumbnailDataModel(DateTime.now(), 3, "Image here"),
          ThumbnailDataModel(DateTime.now(), 4, "Image here"),
          ThumbnailDataModel(DateTime.now(), 5, "Image here"),
          ThumbnailDataModel(DateTime.now(), 6, "Image here"),
        ]);
  }

  Future<bool> uploadImage(int stationCode, int imageId, Credentials cr) async {
    return Future<bool>(() => true);
  }
}
