import 'domainimage.dart';

const String _initId = 'initid';
const String _subInitId = 'subinitid';
const String _locId = 'locid';
const String _userId = 'userid';
const String _imgType = 'imgtype';
const String _imgName = 'imgname';
const String _photoDate = 'photodate';
const String _origImgName = 'origimgname';

class ImageList {
  final List<ImageDetailModel> imageList;

  ImageList(this.imageList);

  factory ImageList.fromJson(List<dynamic> json) {
    print('parsing from json image list');
    print('json is $json');
    List<ImageDetailModel> imagelist = List<ImageDetailModel>();
    imagelist = json.map((item) => ImageDetailModel.fromJson(item)).toList();
    return ImageList(imagelist);
  }
}

//JSON PODO
class ImageDetailModel {
//  final String photoDate;
//  final String initId;
//  final String subInitId;
//  final String locId;
//  final String userId;
//  final String imgType;
  final String imgName;
//  final String origImgName;
//
//  ImageDetailModel(this.photoDate, this.initId, this.subInitId, this.locId,
//      this.userId, this.imgType, this.imgName, this.origImgName);

  ImageDetailModel(this.imgName);

  factory ImageDetailModel.fromJson(Map json) {
    print('parsing json imagedetailmodel');
    print('json is $json');
    print('type for input is ' + json.runtimeType.toString());
    var photoDate = json[_photoDate];
    print('1!!');
    var initid = json[_initId];
    print('2!!');
    var sub = json[_subInitId];
    print('3!!');
    var loc = json[_locId];
    print('4!!');
    var user = json[_userId];
    print('5!!');
    var imgtype = json[_imgType];
    print('6!!');
    var imgname = json[_imgName];
    print('7!!');
    var orig = json[_origImgName];
    print('8!!');
//    const fack = 'fack';
//    ImageDetailModel pop = ImageDetailModel(fack, fack, fack, fack, fack, fack, fack, fack);
    print('9!!');
    ImageDetailModel res = ImageDetailModel(imgname);
    print('10!!');
    print('res is $res');
    print('type for output is ${res.runtimeType}');
    return res;
  }
}

const _isAuthorized = 'valid';
const _isDefault = 'passwordChangeRequired';
const _locationCodes = 'stnList';

//JSON PODO
class AuthorizationModel {
  final bool isAuthorized;
  final bool isDefault;
  final List<Station> stationList;

  AuthorizationModel(this.isAuthorized, this.isDefault, this.stationList);

  factory AuthorizationModel.fromJson(Map json) {
    var isAuthorized = json[_isAuthorized];
    var isDefault = json[_isDefault];
    var locC = json[_locationCodes] as List;
    List<Station> stationList =
    locC.map((item) => Station.fromJson(item)).toList();

    return AuthorizationModel(isAuthorized, isDefault, stationList);
  }
}

//To be used for the database
class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

class Station {
   String stnCode="     ";
   String stnName;
  static const _stationCode = 'stncode';
  static const _stationName = 'stnname';

  Station(this.stnCode, this.stnName);

  factory Station.fromJson(Map json) {
    var stnCode = json[_stationCode];
    var stnName = json[_stationName];
    return Station(stnCode, stnName);
  }
}

const String _message = 'message';
const String _success = 'success';
const String _image = 'image';


class ImageUploadResponse{
  final String message;
  final bool success;
  final domainimage image;

  ImageUploadResponse(this.image, this.success, this.message);

  factory ImageUploadResponse.fromJson(Map json){
    var mss = json[_message];
    var img = domainimage.fromJson(json[_image]);
    var scc = json[_success];
    return ImageUploadResponse(img, scc, mss);
  }
}
