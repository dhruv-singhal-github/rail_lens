import 'package:flutter/material.dart';
import 'consta.dart';
import 'change_password_screen.dart';
import 'bloc.dart';

class LoginScreen extends StatelessWidget {
  var _gContext;

  Widget _showButton(AsyncSnapshot<bool> data) {
    return MaterialButton(
      minWidth: 200,
      height: 50,
      elevation: 5,
      highlightElevation: 8,
      color: consta.color1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: data.hasData?_validateAndSubmit:null,
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 20,
          color: consta.color3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoginBloc();
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
                  StreamBuilder<String>(
                    stream: bloc.username,
                    builder: (context, snapshot) => TextField(
                          onChanged: bloc.usernameChanged,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: consta.color1, width: 10),
//                        borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: consta.color1),
                            ),
                            labelText: 'Username',
                            errorText: snapshot.error,
                            labelStyle: TextStyle(
                              color: consta.color1,
                            ),
                          ),
                        ), //TextField
                  ), //StreamBuilder
                  StreamBuilder<String>(
                    stream: bloc.password,
                    builder: (context, snapshot) => TextField(
                          onChanged: bloc.passwordChanged,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: consta.color1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: consta.color1),
                            ),
                            labelText: 'Password',
                            errorText: snapshot.error,
                            labelStyle: TextStyle(
                              color: consta.color1,
                            ),
                          ), //InputDecoration
                        ), //TextField
                  ), //StreamBuilder
                  StreamBuilder<bool>(
                    stream: bloc.submitCheck,
                    builder: (context, snapshot) => _showButton(snapshot),
                  ),
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
    Navigator.push(_gContext,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
  }
}
