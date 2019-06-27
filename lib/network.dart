import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
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

  static const Duration _timeOutDuration = Duration(milliseconds: 15000);
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
        .timeout(_timeOutDuration)
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
        .timeout(_timeOutDuration)
        .then((response) => response.body)
        .then((body) {
          print('RESPONSE BODY ALERT! $body');
          return body;
        })
        .then(json.decode)
        .then((json) {
          print('parsing to Json');
      return AuthorizationModel.fromJson(json);
    } );
    print('Sending $authorizationModel back to caller');
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
      String locId, String subInitId, Credentials cred) async {
    print('Fetch Image list Basic:' +
        '${base64.encode(utf8.encode('${cred.username}:${cred.password}'))}');
    ImageList imageList = await _client
        .get(
          Uri.parse(_url + _downloadImageList + '/$locId/$subInitId'),
          headers: {
            'accept': 'application/json',
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization':
                'Basic ${base64.encode(utf8.encode('${cred.username}:${cred.password}'))}',
          },
        )
        .timeout(_timeOutDuration)
        .then((response) => response.body)
        .then((body) {
          print('RESPONSE BODY ALERT! $body');
          return body;
        })
        .then(json.decode)
        .then((json) => ImageList.fromJson(json));
    return imageList;
  }

  Future<Stream<String>> uploadImage(
      {@required Station station,
      @required int subInitId,
      @required int sno,
      @required String photoDate,
      @required Credentials cr,
      @required File image}) async {

    print(
        'Upload Basic: ${base64.encode(utf8.encode('${cr.username}:${cr.username}'))}');
    var request = new MultipartRequest('POST', Uri.parse(_url + _upload));

    request.headers['Content-type'] = 'multipart/form-data';
    request.headers['authorization'] =
        'Basic ${base64.encode(utf8.encode('${cr.username}:${cr.password}'))}';
    request.headers['accept'] = 'application/json';

//    var filepath = await _setup_testing();
    var filepath = image.path;
    request.fields['stncode'] = station.stnCode;
    request.fields['subinitid'] = subInitId.toString();
    request.fields['sno'] = sno.toString();
    request.fields['currprev'] = 1.toString();
    request.fields['photodate'] = photoDate;
    request.files.add(
      await MultipartFile.fromPath('file', filepath,
          filename: 'image.txt',
          contentType: MediaType('image', 'jpeg')),
    );


    return await _client.send(request)
    .timeout(_timeOutDuration)
    .then((response){
      print('Response code is ${response.statusCode}');
      if(response.statusCode == 200){
        print('Yay response code is 200');
      }
      return response.stream.transform(utf8.decoder);
    }).catchError((error){
      print('There was an error!');
      print(error);
    });

  }
}

Future<String> _setup_testing() async{
  final directory = await getApplicationDocumentsDirectory();
//  final file = File('${directory.path}/image.txt');
//  file.writeAsStringSync('testing lol');
  print('returning from setup');
  return '${directory.path}/image.txt';
}
