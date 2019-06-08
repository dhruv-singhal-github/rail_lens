//JSON PODO
class ThumbnailDataModel {
  DateTime dateTime;
  int id;
  var thumbnail;
}

const _isAuthorized = 'authorization';
const _isDefault = 'authorization';
const _locationCodes = 'location_details';

//JSON PODO
class AuthorizationModel {
  final bool isAuthorized;
  final bool isDefault;
  final List<String> locationCodes;

  AuthorizationModel(this.isAuthorized, this.isDefault, this.locationCodes);

  factory AuthorizationModel.fromJson(Map json){
    var isAuthorized = json[_isAuthorized];
    var isDefault = json[_isDefault];
    var locC = json[_locationCodes];
    var locationCodes = List<String>.from(locC);
    return AuthorizationModel(isAuthorized, isDefault, locationCodes);
  }
}

//To be used for the database
class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}
