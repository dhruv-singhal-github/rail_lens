import 'package:flutter/material.dart';
import 'dart:async';
import 'HomePage.dart';
import 'consta.dart';
import 'change_password_screen.dart';
import 'bloc_provider.dart';
import 'application_bloc.dart';
import 'models/model.dart';
import 'network.dart';

enum UI_STATE { LOGIN, LOADING, LOGIN_REATTEMPT }

class LoginScreen extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginScreen> {
  StreamSubscription<bool> _submitCheckSubscription;
  StreamSubscription<AuthorizationModel> _authorizationModelSubscription;
  UI_STATE _state = UI_STATE.LOGIN;

  @override
  Widget build(BuildContext context) {
    double width = 500;
    double height = 300;
    return Scaffold(
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
        child: Center(
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
                  child: _uiSelector(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    LoginBloc bloc = Provider.of<LoginBloc>(this.context);
    _submitCheckSubscription = bloc.submitCheck
        .listen(_onSubmitCheckData, onError: _onSubmitCheckError);
    _authorizationModelSubscription = bloc.authorizationStream
        .listen(_onAuthorizationModelData, onError: _onAuthorizationError);

    super.didChangeDependencies();
  }

  void _onSubmitCheckError(Object error, StackTrace trace) {
    print('Handle onSubmitCheck Error');
    print('Error is $error');
    print('Trace is ${trace.toString()}');
  }

  void _onSubmitCheckData(bool isCredentialValid) {
    print('Submit check returned $isCredentialValid');
    if (isCredentialValid) {
      setState(() {
        if (_state == UI_STATE.LOGIN || _state == UI_STATE.LOGIN_REATTEMPT)
          _state = UI_STATE.LOADING;
        else if (_state == UI_STATE.LOADING) {
          print('Duplicate calls!');
          throw Exception('Duplicate values in onSubmit Stream');
        }
      });
    }
  }

  @override
  void dispose() {
    _submitCheckSubscription.cancel();
    _authorizationModelSubscription.cancel();
    super.dispose();
  }

  void _onAuthorizationModelData(AuthorizationModel model) {
    print('Authorization model is  $model');
    if (model.isAuthorized) {
      if (!model.isDefault) {
        print('Open up homepage');
//    final page = BlocProvider<HomePageBloc>(
//      builder: (_, bloc)=>bloc??HomePageBloc(),
//      onDispose: (_, bloc)=> bloc?.dispose(),
//      child: HomePageBloc(),
//    );
        final page = HomePage();
        _openPage(page);
      } else {
        print('Open change default password screen');

        final page = BlocProvider<ChangePasswordBloc>(
          builder: (_, bloc) => bloc ?? ChangePasswordBloc(),
          onDispose: (_, bloc) => bloc?.dispose(),
          child: ChangePasswordScreen(),
        );
        _openPage(page);
      }
    } else {
      print('Wrong username or password');
      if (_state == UI_STATE.LOADING) {
        setState(() {
          _state = UI_STATE.LOGIN_REATTEMPT;
        });
      }
    }
  }

  _openPage(Widget page) {
    Navigator.pushReplacement(this.context,
        MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  _onAuthorizationError(Object error, StackTrace trace) {
    print('Handle authorization error');
    print('Error is $error');
    print('Trace is ${trace.toString()}');
  }

  Widget _uiSelector() {
    switch (_state) {
      case UI_STATE.LOGIN:
        return LoginTextForm();
      case UI_STATE.LOADING:
        return CircularProgressIndicator();
      case UI_STATE.LOGIN_REATTEMPT:
        return LoginTextForm.error('Wrong Username or Password');
      default:
        print('Invalid state');
        throw Exception('Invalid UI state');
    }
  }
}

class LoginTextForm extends StatefulWidget {
  final String _errorMessage;
  final bool _showError;

  @override
  _LoginTextFormState createState() {
    return _LoginTextFormState();
  }

  LoginTextForm()
      : _showError = false,
        _errorMessage = '';

  LoginTextForm.error(this._errorMessage) : _showError = true;
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
        widget._showError
            ? _showErrorBox()
            : Container(
                width: 0,
                height: 0,
              ),
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
    print('Wazzup! Sending event in user/pass streams');
    bloc.usernameChanged(usernameEditController.text);
    bloc.passwordChanged(passwordEditController.text);
  }

  Widget _showErrorBox() {
    return Text(widget._errorMessage);
  }

//  void _openChangePasswordScreen() {
//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
//  }
}
