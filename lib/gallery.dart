import 'package:flutter/material.dart';

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

import 'package:rail_lens/models/photolist.dart';
import 'reusable_ui.dart';

class gallery extends StatelessWidget {
  var loaded = 0;
  List<Image> FullImage = new List();
  List<Image> ThumbnailImage = new List();
  var StationCode = null;
  var imagedomain = null;
  var context;
  var imagecode = null;
  var _isChecked = false;
  var colorscheme = 1;
  var username = 'a';
  String password = 'a';
  var bAuth = 'Basic ' + base64Encode(utf8.encode('a:a'));

  String defaultDate = "Unavailable";
  var colour = consta.color1;
  var colour2 = consta.color2;

  Image defaul = Image.asset(
    "assets/icons/ina.png",
    height: sizeconfig.blockSizeHorizontal * 30,
    width: sizeconfig.blockSizeHorizontal * 30,
    fit: BoxFit.fill,
  );

  gallery(imagedomain, imagecode, colorscheme, StationCode) {
    this.imagedomain = imagedomain;
    this.imagecode = imagecode;
    this.colorscheme = colorscheme;
    this.StationCode = StationCode;

    if (colorscheme == 1) {
      colour = consta.color1;
      colour2 = consta.color2;
    } else {
      colour = consta.color2;
      colour2 = consta.color1;
    }
  }

  Future<photolist> getimage() async {
    print("Sending request: 400");
    String url =
        "http://samvad.cris.org.in/stationimages/rest/stationimages/stnimages/$StationCode/$imagecode";
    final response = await http.get(url, headers: {'authorization': bAuth});

    if (response.statusCode == 200) {
      print("Response: 200");
      return photolist.fromJson(json.decode(response.body));
    } else {
      print("Response: error");
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(context) {
    sizeconfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(imagedomain),
        backgroundColor: consta.color1,
      ),
      body: Container(
        width: sizeconfig.blockSizeHorizontal * 100,
        height: sizeconfig.blockSizeVertical * 100,
        child: FutureBuilder<photolist>(
            future: getimage(),
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
                  FullImage.add(
                    Image.network(
                        "https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                            snapshot.data.photos[i].imagename),
                  );
                  ThumbnailImage.add(Image.network(
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
                            ? imagecontainer(ThumbnailImage[0],
                                snapshot.data.photos[0].date, FullImage,0)
                            : imagecontainer(
                                ((defaul)), defaultDate, FullImage,0),
                        snapshot.data.photos.length >= 2
                            ? imagecontainer(ThumbnailImage[1],
                                snapshot.data.photos[1].date, FullImage,1)
                            : imagecontainer(((defaul)), defaultDate, FullImage,1)
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        snapshot.data.photos.length >= 3
                            ? imagecontainer(ThumbnailImage[2],
                                snapshot.data.photos[2].date, FullImage,2)
                            : imagecontainer(
                                ((defaul)), defaultDate, FullImage,2),
                        snapshot.data.photos.length >= 4
                            ? imagecontainer(ThumbnailImage[3],
                                snapshot.data.photos[3].date, FullImage,3)
                            : imagecontainer(((defaul)), defaultDate, FullImage,3)
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        snapshot.data.photos.length >= 5
                            ? imagecontainer(ThumbnailImage[4],
                                snapshot.data.photos[4].date, FullImage,4)
                            : imagecontainer(
                                ((defaul)), defaultDate, FullImage,4),
                        snapshot.data.photos.length >= 6
                            ? imagecontainer(ThumbnailImage[5],
                                snapshot.data.photos[5].date, FullImage,5)
                            : imagecontainer(((defaul)), defaultDate, FullImage,5)
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
}



class imagecontainer extends StatefulWidget {
  var pic, date, FullImage,index;
  imagecontainer(this.pic, this.date, this.FullImage,this.index);
  @override
  _imagecontainerState createState() =>
      _imagecontainerState(pic, date, FullImage,index);
}

class _imagecontainerState extends State<imagecontainer> {
  var pic, date, index;
  List<Image> FullImage;
  _imagecontainerState(this.pic, this.date, this.FullImage,this.index);

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
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => ViewImage(FullImage,index)));
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
                        _settingModalBottomSheet(context);
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
}

void _settingModalBottomSheet(BuildContext context) {
  print(context);
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.music_note),
                  title: new Text('Gallery'),
                  onTap: () => {}),
              new ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Camera'),
                onTap: () => {},
              ),
            ],
          ),
        );
      });
}
