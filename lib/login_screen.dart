import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'HomePage.dart';
import 'consta.dart';
import 'change_password_screen.dart';
import 'bloc_provider.dart';
import 'application_bloc.dart';
import 'models/model.dart';
import 'network.dart';

class LoginScreen extends StatelessWidget {
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
              child: StreamBuilder(
                  stream: Provider.of<LoginBloc>(context).authorizationStream,
//                stream: bloc.authorizationStream,
                builder: (context, AsyncSnapshot<AuthorizationModel> snapshot) {
                  if (!snapshot.hasData)
                    return LoginTextForm();
                  else
                    return Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: GestureDetector(
                            onTapDown: (adf) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: CircularProgressIndicator(),
                          )),
                    );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget plsDeleteThisFunction(
      BuildContext context, AuthorizationModel authorizationModel) {
    if (!authorizationModel.isDefault && authorizationModel.isAuthorized) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    return CircularProgressIndicator();
  }
}

class LoginTextForm extends StatefulWidget {

  @override
  _LoginTextFormState createState() {
    return _LoginTextFormState();
  }
}

class _LoginTextFormState extends State<LoginTextForm> {
  final usernameEditController = TextEditingController();
  final passwordEditController = TextEditingController();

  @override
  void dispose() {
    usernameEditController.dispose();
    passwordEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        StreamBuilder<String>(
          stream: bloc.username,
          builder: (context, snapshot) => TextField(
                controller: usernameEditController,
//                onChanged: bloc.usernameChanged,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: consta.color1, width: 10),
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
                controller: passwordEditController,
//                onChanged: bloc.passwordChanged,
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
        _showButton(context),
      ],
    );
  }

  Widget _showButton(BuildContext context) {
    return MaterialButton(
      minWidth: 200,
      height: 50,
      elevation: 5,
      highlightElevation: 8,
      color: consta.color1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: () => _validateFields(context),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 20,
          color: consta.color3,
        ),
      ),
    );
  }

  void _validateFields(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context);
    print('Wazzup');
    bloc.usernameChanged(usernameEditController.text);
    bloc.passwordChanged(passwordEditController.text);
  }

//  void _openChangePasswordScreen() {
//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
//  }
}
