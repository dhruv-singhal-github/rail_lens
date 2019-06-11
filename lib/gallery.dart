import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rail_lens/sizeconfig.dart';
import 'package:rail_lens/consta.dart';
import 'package:dotted_border/dotted_border.dart';

class gallery extends StatelessWidget {
  var imagedomain = null;
  var imagecode = null;
  var colorscheme = 1;

  String date = "29/05/1996";
  var colour = consta.color1;
  var colour2=consta.color2;
  gallery(imagedomain, imagecode, colorscheme) {
    this.imagedomain = imagedomain;
    this.imagecode = imagecode;
    this.colorscheme = colorscheme;
    if (colorscheme == 1) {
      colour = consta.color1;
      colour2 = consta.color2;
    }

    else
      {

        colour=consta.color2;
        colour2=consta.color1;

      }
  }

  @override
  Widget build(BuildContext context) {
    sizeconfig().init(context);
    return MaterialApp(
        home: Scaffold(
            body: Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: sizeconfig.blockSizeHorizontal*60,
         // height: sizeconfig.blockSizeVertical*14,
          margin: EdgeInsets.symmetric(vertical: 5),


          child:
        Card(

          
          margin: EdgeInsets.fromLTRB(10, sizeconfig.blockSizeVertical*5, 10, 10),
          
          elevation: 5,
          child:
            Text(imagedomain,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontWeight: FontWeight.bold),)
            ,color: colour2

        )
        )

        ,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            imagecontainer(
                Image(image: AssetImage("assets/icons/info.png")), date),
            imagecontainer(
                Image(image: AssetImage("assets/icons/agra.jpg")), date)
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            imagecontainer(
                Image(image: AssetImage("assets/icons/info.png")), date),
            imagecontainer(
                Image(image: AssetImage("assets/icons/info.png")), date)
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            imagecontainer(
                Image(image: AssetImage("assets/icons/info.png")), date),
            imagecontainer(
                Image(image: AssetImage("assets/icons/info.png")), date)
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
    ))));
  }

  Widget imagecontainer(Image pic, String date) {
    return Container(
        padding: EdgeInsets.all(5),
        width: sizeconfig.blockSizeVertical * 25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly
            ,children: [
          DottedBorder(

            color: colour,
            gap: 3,
            strokeWidth: 2.5,
            child: pic,
          ),
          Container(
            margin: EdgeInsets.all(5),
            child:
          Text(


            date,
            style: TextStyle(color: colour2),
          )
          )
        ]));
  }
}
