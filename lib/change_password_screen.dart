import 'package:flutter/material.dart';
import 'package:rail_lens/HomePage.dart';
import 'consta.dart';
var gconte=null;

class ChangePasswordScreen extends StatelessWidget {
  Widget _showButton() {
    return MaterialButton(
      minWidth: 210,
      height: 50,
      elevation: 5,
      highlightElevation: 8,
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: _validateAndSubmit,
      child: Text(
        'Change Password',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext gconte) {
    double width = 500;
    double height = 500;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: width,
          height: height,
          child: Material(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _showTitle(),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Old Password',
                    ),
                  ), //TextField
                  TextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
//                      hintText: 'Enter Password',
                      labelText: 'New Password',
                    ), //InputDecoration
                  ), //TextField
                  TextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
//                      hintText: 'Enter Password',
                      labelText: 'Confirm Password',
                    ), //InputDecoration
                  ),
                  _showButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _validateAndSubmit() {
    Navigator.push(_gContext,MaterialPageRoute(builder: (context)=>HomePage())) ;

  }

  Widget _showTitle() {
    return Text(
      "Please change the default password",
      style: TextStyle(fontSize: 20),
    );
  }
}
