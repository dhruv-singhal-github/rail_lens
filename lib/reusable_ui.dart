import 'dart:io';

import 'package:flutter/material.dart';
import 'consta.dart';

class LoadingCircular extends StatelessWidget {
  final String message;

  const LoadingCircular({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            message != null
                ? Text(
                    message,
                    style: TextStyle(color: consta.color1, fontSize: 24),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeImageConfirmation extends StatelessWidget{
  final File prevImage;
  final File newImage;

  const ChangeImageConfirmation({Key key, this.prevImage, this.newImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.file(prevImage),
          SizedBox(
            width: 100,
            height: 100,
            child: Icon(Icons.arrow_forward),
          ),
          Image.file(newImage),
        ],
      ),
    );
  }


}
