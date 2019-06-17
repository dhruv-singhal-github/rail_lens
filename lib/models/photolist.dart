import 'package:rail_lens/models/domainimage.dart';
class photolist {
  final List<domainimage> photos;

  photolist({
    this.photos,
  });

  factory photolist.fromJson(List<dynamic> parsedJson) {

    List<domainimage> photos = new List<domainimage>();
    photos = parsedJson.map((i)=>domainimage.fromJson(i)).toList();

    return new photolist(
        photos: photos
    );
  }
}