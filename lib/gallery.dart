import 'package:flutter/material.dart';

import 'package:rail_lens/sizeconfig.dart';
import 'package:rail_lens/consta.dart';
import 'package:rail_lens/models/domainimage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rail_lens/models/photolist.dart';
import 'reusable_ui.dart';

class gallery extends StatelessWidget {
  var StationCode=null;
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

  gallery(imagedomain, imagecode, colorscheme,StationCode) {
    this.imagedomain = imagedomain;
    this.imagecode = imagecode;
    this.colorscheme = colorscheme;
    this.StationCode=StationCode;

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
                print('I have data');
                print('There are ${snapshot.data.photos.length} photos');
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
                            ? imagecontainer(
                                ("https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                                    snapshot.data.photos[0].imagename +
                                    "&thumb=y"),
                                snapshot.data.photos[0].date)
                            : imagecontainer(
                                (("assets/icons/ina.png")), defaultDate),
                        snapshot.data.photos.length >= 2
                            ? imagecontainer(
                                ("https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                                    snapshot.data.photos[1].imagename +
                                    "&thumb=y"),
                                snapshot.data.photos[1].date)
                            : imagecontainer(
                                (("assets/icons/ina.png")), defaultDate)
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        snapshot.data.photos.length >= 3
                            ? imagecontainer(
                                ("https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                                    snapshot.data.photos[2].imagename +
                                    "&thumb=y"),
                                snapshot.data.photos[2].date)
                            : imagecontainer(
                                (("assets/icons/ina.png")), defaultDate),
                        snapshot.data.photos.length >= 4
                            ? imagecontainer(
                                ("https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                                    snapshot.data.photos[3].imagename +
                                    "&thumb=y"),
                                snapshot.data.photos[3].date)
                            : imagecontainer(
                                (("assets/icons/ina.png")), defaultDate)
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        snapshot.data.photos.length >= 5
                            ? imagecontainer(
                                ("https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                                    snapshot.data.photos[4].imagename +
                                    "&thumb=y"),
                                snapshot.data.photos[4].date)
                            : imagecontainer(
                                (("assets/icons/ina.png")), defaultDate),
                        snapshot.data.photos.length >= 6
                            ? imagecontainer(
                                ("https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                                    snapshot.data.photos[5].imagename +
                                    "&thumb=y"),
                                snapshot.data.photos[5].date)
                            : imagecontainer(
                                (("assets/icons/ina.png")), defaultDate)
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

  Widget imageNotPresentIndicator() {
    return imagecontainer((("assets/icons/ina.png")), defaultDate);
  }
}

class imagecontainer extends StatelessWidget {
  String pic, date;
  imagecontainer(this.pic, this.date);

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
            DottedBorder(
              color: consta.color2,
              gap: 3,
              strokeWidth: 2.5,
              child: pic == "assets/icons/ina.png"
                  ? Image.asset(pic)
                  : imagecheck(pic),
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    height: sizeconfig.blockSizeVertical * 9,
                    width: sizeconfig.blockSizeHorizontal * 9,
                    child: FloatingActionButton(
                      onPressed: () {
                        _settingModalBottomSheet(context);
                      },
                      child: const Icon(Icons.add_circle),
                      backgroundColor: consta.color1,
                    )))
          ]),
          Container(
              child: Text(
            date,
            style: TextStyle(color: consta.color2),
          ))
        ]));
    ;
  }
}

class imagecheck extends StatefulWidget {
  var pic;
  imagecheck(var pic) {
    this.pic = pic;
  }

  @override
  _imagecheckState createState() => _imagecheckState(pic);
}

class _imagecheckState extends State<imagecheck> {
  var pic;

  _imagecheckState(var pic) {
    this.pic = pic;
  }

  @override
  Widget build(BuildContext Context) {
    print(context);
    return Image.network(
      pic,
      height: sizeconfig.blockSizeHorizontal * 30,
      width: sizeconfig.blockSizeHorizontal * 30,
      fit: BoxFit.fill,
    );
    //fit(
    //  fit: BoxFit.fill,

    //  child:

    //  Container(
    // height: sizeconfig.blockSizeHorizontal * 30,

    //    decoration: BoxDecoration(
    image:
    Image.network(pic);

    //DecorationImage(image: NetworkImage(pic), fit: BoxFit.fill),
    // )
    // );
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
