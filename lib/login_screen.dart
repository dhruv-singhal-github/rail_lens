import 'package:flutter/material.dart';
enum FormMode { LOGIN, SIGNUP }

class LoginScreen extends StatelessWidget {

  var _formMode = FormMode.LOGIN;
  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: _formMode == FormMode.LOGIN
              ? new Text('Login',
              style: new TextStyle(fontSize: 20.0, color: Colors.white))
              : new Text('Create account',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
          shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        ));
  }

  Widget _showButton(){
    return MaterialButton(
      minWidth: 200,
      height: 50,
      elevation: 5,
      highlightElevation: 8,
      color: Colors.blue[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: _validateAndSubmit,
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[200],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = 500;
    double height = 300;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: width,
          height: height,
          child: Material(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
//                      hintText: 'Enter Username',
                      labelText: 'Username',
                    ),
                  ), //TextField
                  TextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
//                      hintText: 'Enter Password',
                      labelText: 'Password',
                    ), //InputDecoration
                  ), //TextField
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
    print('Wazzup');
  }
}
