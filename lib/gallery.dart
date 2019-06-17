import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rail_lens/sizeconfig.dart';
import 'package:rail_lens/consta.dart';
import 'package:rail_lens/models/domainimage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:rail_lens/models/photolist.dart';

class gallery extends StatelessWidget {
  var imagedomain = null;
  var imagecode = null;
  var _isChecked = false;
  var colorscheme = 1;
  var username = 'a';
  String password = 'a';
  var bAuth = 'Basic ' + base64Encode(utf8.encode('a:a'));

  String date = "29/05/1996";
  var colour = consta.color1;
  var colour2 = consta.color2;
  gallery(imagedomain, imagecode, colorscheme) {
    this.imagedomain = imagedomain;
    this.imagecode = imagecode;
    this.colorscheme = colorscheme;

    if (colorscheme == 1) {
      colour = consta.color1;
      colour2 = consta.color2;
    } else {
      colour = consta.color2;
      colour2 = consta.color1;
    }
  }

  Future<photolist> getimage() async {
    print("400");
    String url =
        "http://samvad.cris.org.in/stationimages/rest/stationimages/stnimages/DLI/$imagecode";
    final response = await http.get(url, headers: {'authorization': bAuth});

    if (response.statusCode == 200) {
      print("200");
      return photolist.fromJson(json.decode(response.body));
    } else {
      print("error");
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeconfig().init(context);

    return MaterialApp(
        home: Scaffold(
            body: Container(
                width: sizeconfig.blockSizeHorizontal * 100,
                height: sizeconfig.blockSizeVertical * 100,
                child: FutureBuilder<photolist>(
                    future: getimage(),
                    builder: (context, snapshot) {
                      if (snapshot == null) {
                        print("nullsnp");
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        //checks if the response throws an error
                        return

                        CircularProgressIndicator();
                      }
                      else if (snapshot.hasData) {
                        date = snapshot.data.photos[0].date;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children: <Widget>[
                            Container(
                                width: sizeconfig.blockSizeHorizontal * 60,
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
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontWeight: FontWeight.bold),
                                        )))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                imagecontainer(
                                    (("https://www.raildrishti.in/raildrishti/IRDBSubInitFileDownload?fname=" +
                                        snapshot.data.photos[0].imagename +
                                        "&thumb=y")),
                                    date),
                                imagecontainer(
                                    (("assets/icons/agra.jpg")), date)
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                imagecontainer(
                                    (("assets/icons/info.png")), date),
                                imagecontainer(
                                    (("assets/icons/info.png")), date)
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                imagecontainer(
                                    (("assets/icons/info.png")), date),
                                imagecontainer(
                                    (("assets/icons/info.png")), date)
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
                    }))));
  }

  Widget imagecontainer(String pic, String date) {
    return Container(
        //margin:
         //   EdgeInsets.symmetric(vertical: sizeconfig.blockSizeVertical * 2.5),
        //     padding: EdgeInsets.all(5),
        width: sizeconfig.blockSizeHorizontal * 35,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          DottedBorder(
            color: colour,
            gap: 3,
            strokeWidth: 2.5,
            child: imagecheck(pic),
          ),
          Container(
              child: Text(
            date,
            style: TextStyle(color: colour2),
          ))
        ]));
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
  Widget build(BuildContext context) {
    return

    Image.network(pic,height: sizeconfig.blockSizeHorizontal*30,width: sizeconfig.blockSizeHorizontal*30,fit: BoxFit.fill,);
        //fit(
        //  fit: BoxFit.fill,

        //  child:

      //  Container(
           // height: sizeconfig.blockSizeHorizontal * 30,
        //    decoration: BoxDecoration(
              image:Image.network(pic);


    //DecorationImage(image: NetworkImage(pic), fit: BoxFit.fill),
           // )
   // );
  }
}
