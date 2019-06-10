import 'package:flutter/material.dart';
import 'dart:async';
import 'HomePage.dart';
import 'consta.dart';
import 'change_password_screen.dart';
import 'bloc_provider.dart';
import 'application_bloc.dart';
import 'models/model.dart';
import 'debug_code.dart';

enum _UI_STATE { LOGIN, LOADING, LOGIN_REATTEMPT }

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  StreamSubscription<bool> _submitCheckSubscription;
  StreamSubscription<AuthorizationModel> _authorizationModelSubscription;
  _UI_STATE _state = _UI_STATE.LOGIN;

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
        if (_state == _UI_STATE.LOGIN || _state == _UI_STATE.LOGIN_REATTEMPT)
          _state = _UI_STATE.LOADING;
        else if (_state == _UI_STATE.LOADING) {
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
    printAuthorizationModel(model);
    if (model.isAuthorized) {
      if (!model.isDefault) {
        print('Open up homepage');
//    final page = BlocProvider<HomePageBloc>(
//      builder: (_, bloc)=>bloc??HomePageBloc(),
//      onDispose: (_, bloc)=> bloc?.dispose(),
//      child: HomePageBloc(),
//    );
        //Save in database
        LoginBloc bloc = Provider.of<LoginBloc>(context);
        Provider.of<ApplicationBloc>(context)
            .storeCredentials(bloc.lastUsername, bloc.lastPassword);
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
      if (_state == _UI_STATE.LOADING) {
        setState(() {
          _state = _UI_STATE.LOGIN_REATTEMPT;
        });
      } else{
        print('Currently in an invalid state!! state was supposed to be '
            'UI_STATE.LOADING, it is $_state');
      }
    }
  }

  void _openPage(Widget page) {
    Navigator.pushReplacement(this.context,
        MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  void _onAuthorizationError(Object error, StackTrace trace) {
    print('Handle authorization error');
    print('Error is $error');
    print('Trace is ${trace.toString()}');
  }

  Widget _uiSelector() {
    switch (_state) {
      case _UI_STATE.LOGIN:
        return _LoginForm();
      case _UI_STATE.LOADING:
        return CircularProgressIndicator();
      case _UI_STATE.LOGIN_REATTEMPT:
        return _LoginForm.error();
      default:
        print('Invalid UI state');
        throw Exception('Invalid UI state');
    }
  }
}

class _LoginForm extends StatefulWidget {
  final String errorMessage;
  final bool _showError;

  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }

  _LoginForm()
      : _showError = false,
        errorMessage = '';

  _LoginForm.error({this.errorMessage = 'Wrong Username or Password'})
      : _showError = true;
}

class _LoginFormState extends State<_LoginForm> {
  final _usernameEditController = TextEditingController();
  final _passwordEditController = TextEditingController();

  @override
  void dispose() {
    _usernameEditController.dispose();
    _passwordEditController.dispose();
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
                controller: _usernameEditController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  errorText: snapshot.error,
                ),
              ), //TextField
        ), //StreamBuilder
        StreamBuilder<String>(
          stream: bloc.password,
          builder: (context, snapshot) => TextField(
                controller: _passwordEditController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  errorText: snapshot.error,
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
    bloc.usernameChanged(_usernameEditController.text);
    bloc.passwordChanged(_passwordEditController.text);
  }

  Widget _showErrorBox() {
    return Text(widget.errorMessage);
  }

//  void _openChangePasswordScreen() {
//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
//  }
}
