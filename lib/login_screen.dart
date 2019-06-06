import 'package:flutter/material.dart';
import 'consta.dart';
import 'change_password_screen.dart';
class LoginScreen extends StatelessWidget {

  var _gContext;

  Widget _showButton(){
    return MaterialButton(
      minWidth: 200,
      height: 50,
      elevation: 5,
      highlightElevation: 8,
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: _validateAndSubmit,
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _gContext = context;
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
    Navigator.push(_gContext,MaterialPageRoute(builder: (context)=>ChangePasswordScreen())) ;
  }
}
