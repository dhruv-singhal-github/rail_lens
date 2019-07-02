import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rail_lens/sizeconfig.dart';
import 'package:rail_lens/consta.dart';
import 'package:rail_lens/models/domainimage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rail_lens/ViewImage.dart';
import 'package:rail_lens/HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:rail_lens/models/photolist.dart';
import 'models/model.dart';
import 'reusable_ui.dart';
import 'file_compression.dart';
import 'package:path/path.dart' as p;

class Gallery extends StatefulWidget {
//  var loaded = 0;
  final Station station;
  String get stationCode => station.stnCode;
  final String imageDomain;
//  var context;
  final int imageCode;

  var colorScheme = 1;

  var colour = consta.color1;
  var colour2 = consta.color2;

  Gallery(this.imageDomain, this.imageCode, this.colorScheme, this.station) {
    if (colorScheme == 1) {
      colour = consta.color1;
      colour2 = consta.color2;
    } else {
      colour = consta.color2;
      colour2 = consta.color1;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return GalleryState();
  }
}

class GalleryState extends State<Gallery> {
  List<Image> fullImage = new List();
  List<Image> thumbnailImage = new List();
  List<num> imageSno = new List();
  final String defaultDate = "Unavailable";
  final Image defaultImage = Image.asset(
    "assets/icons/ina.png",
    height: sizeconfig.blockSizeHorizontal * 30,
    width: sizeconfig.blockSizeHorizontal * 30,
    fit: BoxFit.fill,
  );
  //TODO: remove hardcoded credentials
  final String bAuth = 'Basic ' + base64Encode(utf8.encode('a:a'));
  //  var _isChecked = false;

//  var username = 'a';
//  String password = 'a';

  Future<photolist> getImages() async {
    print("Sending request: 400");
    String url =
        "http://samvad.cris.org.in/stationimages/rest/stationimages/stnimages/${widget.stationCode}/${widget.imageCode}";
    final response = await http.get(url, headers: {'authorization': bAuth});

    if (response.statusCode == 200) {
      print("Response: 200");
      return photolist.fromJson(json.decode(response.body));
    } else {
      print("Response: error");
      throw Exception('Failed to load post');
    }
  }

  File _selectedImage;

  @override
  Widget build(context) {
    sizeconfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.imageDomain),
        backgroundColor: consta.color1,
      ),
      body: Container(
        width: sizeconfig.blockSizeHorizontal * 100,
        height: sizeconfig.blockSizeVertical * 100,
        child: FutureBuilder<photolist>(
            future: getImages(),
            builder: (Context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                print("nullsnp");
                return LoadingCircular(message: 'Connecting to our database');
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                //checks if the response throws an error
                return LoadingCircular(
                  message: 'Loading Pictures...',
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                /*   FullImage.add(Image.network(
                    "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                        snapshot.data.photos[0].imagename));
                FullImage.add(Image.network(
                    "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                        snapshot.data.photos[1].imagename));
                FullImage.add(Image.network(
                    "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                        snapshot.data.photos[2].imagename));
                FullImage.add(Image.network(
                    "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                        snapshot.data.photos[3].imagename));
                FullImage.add(Image.network(
                    "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                        snapshot.data.photos[4].imagename));
                FullImage.add(Image.network(
                    "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                        snapshot.data.photos[5].imagename));*/
                print('I have data');
                print('There are ${snapshot.data.photos.length} photos');
                for (int i = 0; i < snapshot.data.photos.length; i++) {
                  print('Detected sno ${snapshot.data.photos[i].sno}');
                  imageSno.add(snapshot.data.photos[i].sno);
                  fullImage.add(
                    Image.network(
                        "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                            snapshot.data.photos[i].imagename),
                  );
                  thumbnailImage.add(Image.network(
                    "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                        snapshot.data.photos[i].imagename +
                        "&thumb=y",
                    height: sizeconfig.blockSizeHorizontal * 30,
                    width: sizeconfig.blockSizeHorizontal * 30,
                    fit: BoxFit.fill,
                  ));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    /*  Container(
++                        width: sizeconfig.blockSizeHorizontal * 60,
                        height: sizeconfig.blockSizeVertical * 8,
                        margin: EdgeInsets.fromLTRB(
                            0, sizeconfig.blockSizeVertical * 5, 0, 0),
                        child: Card(
                            color: colour2,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            elevation: 5,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  imagedomain,
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontWeight: FontWeight.bold),
                                )))),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        snapshot.data.photos.length >= 1
                            ? ImageContainer(
                                thumbnailImage[0],
                                snapshot.data.photos[0].date,
                                fullImage,
                                0,
                                getImageFromUser)
                            : ImageContainer(((defaultImage)), defaultDate,
                                fullImage, 0, getImageFromUser),
                        snapshot.data.photos.length >= 2
                            ? ImageContainer(
                                thumbnailImage[1],
                                snapshot.data.photos[1].date,
                                fullImage,
                                1,
                                getImageFromUser)
                            : ImageContainer(((defaultImage)), defaultDate,
                                fullImage, 1, getImageFromUser)
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        snapshot.data.photos.length >= 3
                            ? ImageContainer(
                                thumbnailImage[2],
                                snapshot.data.photos[2].date,
                                fullImage,
                                2,
                                getImageFromUser)
                            : ImageContainer(((defaultImage)), defaultDate,
                                fullImage, 2, getImageFromUser),
                        snapshot.data.photos.length >= 4
                            ? ImageContainer(
                                thumbnailImage[3],
                                snapshot.data.photos[3].date,
                                fullImage,
                                3,
                                getImageFromUser)
                            : ImageContainer(((defaultImage)), defaultDate,
                                fullImage, 3, getImageFromUser)
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        snapshot.data.photos.length >= 5
                            ? ImageContainer(
                                thumbnailImage[4],
                                snapshot.data.photos[4].date,
                                fullImage,
                                4,
                                getImageFromUser)
                            : ImageContainer(((defaultImage)), defaultDate,
                                fullImage, 4, getImageFromUser),
                        snapshot.data.photos.length >= 6
                            ? ImageContainer(
                                thumbnailImage[5],
                                snapshot.data.photos[5].date,
                                fullImage,
                                5,
                                getImageFromUser)
                            : ImageContainer(((defaultImage)), defaultDate,
                                fullImage, 5, getImageFromUser)
                      ],
                    )
                  ],
                  /*GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this would produce 2 rows.
      crossAxisCount: 2,
      // Generate 100 Widgets that display their index in the List
      children: List.generate(6, (index) {
        return Center(*/
                );
              }
            }),
      ),
    );
  }

  //Widget imageNotPresentIndicator() {
  //return imagecontainer((defaul), defaultDate, FullImage);
  //}

  Future<void> getImageFromUser(
      bool isCamera, Image prevImage, int index) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    //TODO: This is inefficient!!
    print('Image we got is ${image}');

    var tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp('compressed');
    File compressedFile = File('${tempDir.path}/${p.basename(image.path)}');
    await compressImage(image, compressedFile);
    _selectedImage = compressedFile;
    num sno;
    if (imageSno.length <= index) {
      sno = imageSno.length;
    } else {
      sno = imageSno[index];
    }
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return AlertDialog(

          title: new Text('You sure hon?'),
          content: new ChangeImageConfirmation(
            prevImage: prevImage,
            newImage: _selectedImage,
            station: widget.station,
            subInitId: widget.imageCode,
            sno: sno,
          ),
        );
      },
    );
  }

  Future<void> compressImage(File originalImageFile, File fileToSaveTo) {
    return compute(compressImageFile, [originalImageFile, fileToSaveTo]);
  }
}

class ImageContainer extends StatefulWidget {
  final pic, date, fullImage, index, getImageFromUser;
  ImageContainer(
      this.pic, this.date, this.fullImage, this.index, this.getImageFromUser);
  @override
  _ImageContainerState createState() =>
      _ImageContainerState(pic, date, fullImage, index, getImageFromUser);
}

class _ImageContainerState extends State<ImageContainer> {
  var pic, date, index;
  List<Image> fullImage;
  Function(bool isCamera, Image prevImage, int index) getImageFromUser;
  _ImageContainerState(
      this.pic, this.date, this.fullImage, this.index, this.getImageFromUser);

  @override
  Widget build(BuildContext context) {
    return Container(

        //margin:
        //   EdgeInsets.symmetric(vertical: sizeconfig.blockSizeVertical * 2.5),
        //     padding: EdgeInsets.all(5),
        width: sizeconfig.blockSizeHorizontal * 35,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Stack(children: [
            //   Shimmer.fromColors(
            //   baseColor: Colors.grey[200],
            //   highlightColor: Colors.grey[300],
            //   child:
            GestureDetector(
              onTap: () {
                print(date);
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => ViewImage(fullImage, index)));
              },
              child: DottedBorder(
                  color: consta.color2, gap: 3, strokeWidth: 2.5, child: pic
                  //       : imagecheck(pic),
                  ),
            ),
            //   GestureDetector(onTap: (){

            //    print(date);

            //  },),
            //   ),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    height: sizeconfig.blockSizeVertical * 9,
                    width: sizeconfig.blockSizeHorizontal * 9,
                    child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        _settingModalBottom(context);
                      },
                      child: const Icon(Icons.add_circle),
                      backgroundColor: consta.color1,
                    )))
          ]),
          //  Shimmer.fromColors(
          //    baseColor: Colors.grey[200],
          //    highlightColor: Colors.grey[300],
          //    child:
          Container(
            //width: sizeconfig.blockSizeHorizontal * 30,
            //height: sizeconfig.blockSizeHorizontal * 1,
            //   child: Image.asset(("assets/icons/ina.png")),
            child: Text(
              date,
              style: TextStyle(color: consta.color2),
              // )
            ),
          )
        ]));
  }

  void _settingModalBottom(BuildContext context) {
    print(context);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.folder),
                    title: new Text('Gallery'),
                    onTap: () => {getImageFromUser(false, pic, index)}),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Camera'),
                  onTap: () => {getImageFromUser(true, pic, index)},
                ),
              ],
            ),
          );
        });
  }
}
