import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rail_lens/reusable_ui.dart';

import 'HomePage.dart';
import 'application_bloc.dart';
import 'bloc_provider.dart';
import 'consta.dart';
import 'debug_code.dart';
import 'models/model.dart';

enum _UI_STATE { CHANGE_FORM, LOADING, CHANGE_FORM_REATTEMPT }

class ChangePasswordScreen extends StatefulWidget {
  final bool mandatory;

  const ChangePasswordScreen({Key key, @required this.mandatory})
      : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordScreen> {
  _UI_STATE _state = _UI_STATE.CHANGE_FORM;
  StreamSubscription<bool> _validEntriesSubscription;
  StreamSubscription<AuthorizationModel> _authorizationModelSubscription;
  @override
  Widget build(BuildContext context) {
    double width = 500;
    double height = 500;

    return Scaffold(
      appBar: AppBar(
        title: Text("RailLens"),
        backgroundColor: consta.color1,
        elevation: 0,
        actions: <Widget>[

        ],
      ),
      resizeToAvoidBottomPadding: true,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Center(
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
                    child: _uiSelector(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uiSelector() {
    print('uiSelector called with $_state');
    switch (_state) {
      case _UI_STATE.CHANGE_FORM:
        return _ChangePasswordForm();
      case _UI_STATE.LOADING:
        return LoadingCircular();
      case _UI_STATE.CHANGE_FORM_REATTEMPT:
        return _ChangePasswordForm.error();
      default:
        print('Invalid UI state');
        throw Exception('Invalid UI state');
    }
  }

  @override
  void didChangeDependencies() {
    ChangePasswordBloc bloc = Provider.of<ChangePasswordBloc>(this.context);
    _validEntriesSubscription = bloc.validEntries
        .listen(_onValidEntriesData, onError: _onValidEntriesError);
    _authorizationModelSubscription = bloc.authorizationStream
        .listen(_onAuthorizationModelData, onError: _onAuthorizationError);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _validEntriesSubscription.cancel();
    _authorizationModelSubscription.cancel();
    super.dispose();
  }

  void _onValidEntriesData(bool event) {
    print('Valid Entries returned $event');
    if (event) {
      setState(() {
        print('Setting to loading state');
        if (_state == _UI_STATE.CHANGE_FORM || _state == _UI_STATE.CHANGE_FORM)
          _state = _UI_STATE.LOADING;
        else if (_state == _UI_STATE.LOADING) {
          print('Duplicate calls!');
          throw Exception('Duplicate values in onValid stream');
        }
      });
    }
  }

  void _onValidEntriesError(Object error, StackTrace trace) {
    print('Handle onValidEntries Error');
    print('Error is $error');
    print('Trace is ${trace.toString()}');
  }

  void _onAuthorizationModelData(AuthorizationModel model) {
    printAuthorizationModel(model);
    if (model == null) {
      _onAuthorizationError(
          'Null AuthorizationModel', StackTrace.fromString('Not Available'));
      return;
    }
    if (model.isAuthorized) {
      if (!model.isDefault) {
        //authorized and changed successfully
        print('Open up homepage');
        ChangePasswordBloc bloc = Provider.of<ChangePasswordBloc>(this.context);
        Provider.of<ApplicationBloc>(this.context)
            .storePassword(bloc.lastPassword);
        final page = HomePage();
        _openPage(page);
      } else {
        //not changed
        print('new password is not set, setting to reattempt state');
        if (_state == _UI_STATE.LOADING) {
          setState(() {
            _state = _UI_STATE.CHANGE_FORM_REATTEMPT;
          });
        } else {
          print('Currently in an invalid state!! state was supposed to be '
              'UI_STATE.LOADING, it is $_state');
        }
      }
    } else {
      //not authorized
      print('Wrong oldpass');
      //TODO: Signify somehow to user that oldpass was wrong
      if (_state == _UI_STATE.LOADING) {
        setState(() {
          _state = _UI_STATE.CHANGE_FORM_REATTEMPT;
        });
      } else {
        print('Currently in an invalid state!! state was supposed to be '
            'UI_STATE.LOADING, it is $_state');
      }
    }
  }

  void _onAuthorizationError(Object error, StackTrace trace) {
    print('Handle onAuthorization Error');
    print('Error is $error');
    print('Trace is ${trace.toString()}');
    setState(() {
      if (_state == _UI_STATE.LOADING)
        _state = _UI_STATE.CHANGE_FORM_REATTEMPT;
      else if (_state == _UI_STATE.CHANGE_FORM_REATTEMPT ||
          _state == _UI_STATE.CHANGE_FORM) {
        print('Duplicate calls!');
        throw Exception(
            'Duplicate values in onAuthorize Stream in ChangePassword');
      }
    });
  }

  void _openPage(Widget page) {
    if (widget.mandatory)
      Navigator.pushReplacement(this.context,
          MaterialPageRoute(builder: (context) {
        return page;
      }));
    else
      Navigator.pop(
        this.context,
      );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  final String errorMessage;
  final bool _showError;

  _ChangePasswordForm()
      : _showError = false,
        errorMessage = '';

  _ChangePasswordForm.error(
      {this.errorMessage = 'Some Error Occured! Please try again'})
      : _showError = true;

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _oldPassEditController = TextEditingController();
  final _newPassEditController = TextEditingController();
  final _confPassEditController = TextEditingController();

  @override
  void dispose() {
    _oldPassEditController.dispose();
    _newPassEditController.dispose();
    _confPassEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ChangePasswordBloc>(context);
    final double dividerSize = 25;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: dividerSize,
        ),
        _showTitle(),
        SizedBox(
          height: dividerSize,
        ),
        widget._showError
            ? _showErrorBox()
            : Container(
                width: 0,
                height: 0,
              ),
        SizedBox(
          height: dividerSize,
        ),
        StreamBuilder<String>(
//          stream: bloc.,TODO: Create old pass stream
          builder: (c, snapshot) => TextField(
                keyboardType: TextInputType.text,
                controller: _oldPassEditController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Old Password',
//              errorText: snapshot.error,
                ),
              ),
        ), //TextField
        SizedBox(
          height: dividerSize,
        ),
        StreamBuilder<String>(
          stream: bloc.newPassword,
          builder: (_, snapshot) => TextField(
                keyboardType: TextInputType.text,
                controller: _newPassEditController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New Password',
                  errorText: snapshot.error,
                ), //InputDecoration
              ),
        ), //TextField
        SizedBox(
          height: dividerSize,
        ),
        StreamBuilder(
          stream: bloc.confirmPassword,
          builder: (_, snapshot) => TextField(
                keyboardType: TextInputType.text,
                controller: _confPassEditController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  errorText: snapshot.error,
                  //TODO: This ugly^  Change please
                ), //InputDecoration
              ),
        ),
        SizedBox(
          height: dividerSize * 1.5,
        ),
        _showButton(context),
        SizedBox(
          height: dividerSize,
        )
      ],
    );
  }

  Widget _showButton(BuildContext context) {
    return MaterialButton(
      minWidth: 210,
      height: 50,
      elevation: 5,
      highlightElevation: 8,
      color: consta.color1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: () => _validateAndSubmit(context),
      child: Text(
        'Save Password',
        style: TextStyle(
          fontSize: 16,
          color: consta.color3,
        ),
      ),
    );
  }

  Widget _showTitle() {
    return Text(
      "Please change the default password",
      style: TextStyle(fontSize: 20),
    );
  }

  void _validateAndSubmit(BuildContext context) {
    final bloc = Provider.of<ChangePasswordBloc>(context);
    print('Wazzup! Sending event in change pass streams');
    bloc.oldPassChanged(_oldPassEditController.text);
    bloc.newPassChanged(_newPassEditController.text);
    bloc.confirmPassChanged(_confPassEditController.text);
  }

  Widget _showErrorBox() {
    return Text(widget.errorMessage);
  }
}
