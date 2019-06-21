import 'dart:io';
import 'package:flutter/foundation.dart';

import 'network.dart';
import 'package:flutter/material.dart';
import 'application_bloc.dart';
import 'bloc_provider.dart';
import 'consta.dart';
import 'models/model.dart';

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

//TODO: Move this in its own file!!
class ChangeImageConfirmation extends StatefulWidget {
  final File prevImage;
  final File newImage;
  final Station station;
  final int subInitId;
  final int sno;

  const ChangeImageConfirmation(
      {Key key,
      @required this.prevImage,
      @required this.newImage,
      @required this.station,
      @required this.subInitId,
      @required this.sno})
      : super(key: key);

  @override
  ChangeImageState createState() {
    return ChangeImageState();
  }
}

class ChangeImageState extends State<ChangeImageConfirmation> {
  DateTime _selectedDate = DateTime.now();
  ApplicationBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<ApplicationBloc>(this.context);
    super.didChangeDependencies();
  }

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
            onPressed: () => _confirmUpload(),
            child: Text('Confirm'),
          )
        ],
      ),
    );
  }

  void _confirmUpload() {

  }

  _networkUpload() async {
    Credentials cred = await _bloc.getCredentials();
    return FutureBuilder(
      future: RailApi().uploadImage(
          station: widget.station,
          subInitId: widget.subInitId,
          sno: widget.sno,
          photoDate:
          '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
          cr: cred,
          image: widget.newImage),
      builder: (context, snapshot){

        if (snapshot.connectionState == ConnectionState.none) {
          print('no connection!!');
          return LoadingCircular(
            message: 'Preparing...',
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          print('waiting on connection!');
          return LoadingCircular(
            message: 'Uploading',
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          print('Completed with something!');
          print('Data is ${snapshot.data}');
          if(snapshot.hasError){
            print('Completed with an error');
            print('Error is ${snapshot.error}');
            return Text('Error is ${snapshot.error}');
          }

          if (snapshot.hasData) {
            var val = (snapshot.data as Stream);
            print('Upload returned');
            return StreamBuilder(
              stream: val,
              builder: (_,snap){
                if(snap.hasData){
                  return Text('snap has ${snap.data}');
                }
                else return Text('snap dont have shit');
              },
            );
          } else {
            print('Connection done but no data');
            return Text('Connection done but no data!');
          }
        } else {
          print('Something weird has happened');
          return Text('Something weird has happened');
        }

      },
    );
  }
}
