import 'models/model.dart';

void printAuthorizationModel(AuthorizationModel m){
 print('AuthorizationModel is {${m?.isAuthorized}, ${m?.isDefault}, ${m?.stationList}}');
}