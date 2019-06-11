import 'package:flutter/material.dart';
import 'package:rail_lens/consta.dart';
import 'package:rail_lens/sizeconfig.dart';
import 'package:rail_lens/main.dart';
import 'package:rail_lens/gallery.dart';
import 'package:rail_lens/login_screen.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';
BuildContext context;
var Context=null;

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
          appBar: AppBar(
            title: Text("RailLens"),
            backgroundColor: consta.color1,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                  icon: Image.asset(
                    "assets/icons/logout.png",
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  onPressed: null)
            ],
          ),
          body: Container(
            color: Color.fromRGBO(255, 255, 255, 1),
            child: content(),
          ),
        );
  }
}


class content extends StatefulWidget {
  @override
  _contentState createState() => _contentState();
}

class _contentState extends State<content> {
  String StationCode = "DLI";
  String StationForm = "Old Delhi Railway Station";
  @override
  Widget build(BuildContext context) {
    sizeconfig().init(context);
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [consta.color1, Color.fromRGBO(255, 255, 255, 1)],
          begin: Alignment.topCenter,
          end: Alignment.center,
        )),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                color: Color.fromRGBO(255, 255, 255, 1),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                          child: Text(
                        StationCode,
                        style: TextStyle(
                            color: consta.color1,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )),
                      VerticalDivider(
                          indent: 0, width: 15, color: consta.color2),
                      Container(
                          width: 220,
                          child: Text(
                            StationForm,
                            style:
                                TextStyle(color: consta.color2, fontSize: 15),
                          )),
                      Image.asset(

                        "assets/icons/search.png",
                        color: consta.color1,
                        width: 30,
                      )
                    ],
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Color(0x000000),
                  child: iconplate(),
                )),

          ],
        ));
  }
}

class  iconplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
          color: Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    iconwdg(
                        IconButton(

                            icon: Image.asset(
                              "assets/icons/face.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => gallery("Station Facade", 44, 1)
                              ));
                            })
                        ,
                        "Station Facade"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/circ.png",
                              color: consta.color1,
                            ),
                            onPressed:() {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Circulating Area", 44, 2)
                              ));
                            }),
                        "Circulating Area"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset("assets/icons/tube.png",
                                color: consta.color1),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Illumination", 44, 1)
                              ));
                            }),
                        "Illumination"),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/waitingroom.png",
                              color: consta.color1,
                            ),
                            onPressed:() {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Waiting Room", 44, 2)
                              ));
                            }),
                        "Waiting Room"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/platform.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Platform", 44, 1)
                              ));
                            }),
                        "Platform"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/food.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Refreshment Rooms", 44, 2)
                              ));
                            }),
                        "Refreshment Rooms"),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    iconwdg(
                        IconButton(
                            icon: Image.asset("assets/icons/taj.png",
                                color: consta.color1),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Local Heritage", 44, 1)
                              ));
                            }),
                        "Local Heritage"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/stair.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Bridges and Escalators", 44, 2)
                              ));
                            }),
                        "Bridges and Escalators"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset("assets/icons/elevator.png",
                                color: consta.color1),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Lifts", 44, 1)
                              ));
                            }),
                        "Lifts"),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/info.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Information Displays", 44, 2)
                              ));
                            }),
                        "Information Displays"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset(
                              "assets/icons/mslefemsle.png",
                              color: consta.color1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Restrooms", 44, 1)
                              ));
                            }),
                        "Restrooms"),
                    iconwdg(
                        IconButton(
                            icon: Image.asset("assets/icons/gear.png",
                                color: consta.color1),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      gallery("Others", 44, 2)
                              ));
                            }),
                        "Others"),
                  ])
            ],
          ),
        ));
  }
}

Widget iconwdg(IconButton domain, String domainname) {

  // double width = MediaQuery.of(context).size.width;
  return Container(
    width: 110,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),


   child:
    Column(
      children: <Widget>[
        domain,
        Text(
          domainname,
          textAlign: TextAlign.center,
          style: TextStyle(color: consta.color2,fontSize: sizeconfig.blockSizeHorizontal*3.5),
        )
      ],
    ),
  );
}
