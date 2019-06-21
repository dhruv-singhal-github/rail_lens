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

class ChangeImageConfirmation extends StatefulWidget {
  final File prevImage;
  final File newImage;

  const ChangeImageConfirmation({Key key, this.prevImage, this.newImage})
      : super(key: key);

  @override
  ChangeImageState createState() {
    return ChangeImageState();
  }
}

class ChangeImageState extends State<ChangeImageConfirmation> {
  DateTime _selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2017),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.file(widget.prevImage),
              SizedBox(
                width: 100,
                height: 100,
                child: Icon(Icons.arrow_forward),
              ),
              Column(
                children: <Widget>[
                  Image.file(widget.newImage),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text("${_selectedDate.toLocal()}"),
                  ),
                ],
              ),
            ],
          ),
          RaisedButton(
            onPressed: ()=>_confirmUpload(),
            child: Text('Confirm'),
          )
        ],
      ),
    );
  }

  void _confirmUpload() {

  }
}
