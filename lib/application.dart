import 'dart:async';

import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'application_bloc.dart';
import 'bloc_provider.dart';
import 'consta.dart';
import 'debug_code.dart' as debug;
import 'login_screen.dart';
import 'models/model.dart';
import 'reusable_ui.dart';

void main() => runApp(new Application());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationBloc>(
      builder: (_, bloc) => bloc ?? ApplicationBloc(),
      onDispose: (_, bloc) => bloc?.dispose(),
      child: new MaterialApp(
        title: 'RailLens',
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        home: ApplicationStateManager(),
      ),
    );
  }
}

class ApplicationStateManager extends StatefulWidget {

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<ApplicationStateManager> {
  StreamSubscription<AuthorizationModel> _isLoggedInStream;
  ApplicationBloc _bloc;
  //TODO: Replace StreamBuilder with custom stream logic


  @override
  Widget build(BuildContext context) {
    return LoadingPage();
  }

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<ApplicationBloc>(context);
    _isLoggedInStream = _bloc.isLoggedIn.listen(_onIsLoggedInData, onError: _onIsLoggedInError);
    super.didChangeDependencies();
  }

  Widget buildHomePage() {
//    final page = BlocProvider<HomePageBloc>(
//      builder: (_, bloc)=>bloc??HomePageBloc(),
//      onDispose: (_, bloc)=> bloc?.dispose(),
//      child: HomePageBloc(),
//    );
    return HomePage();
  }

  Widget buildLoginPage() {
    final page = BlocProvider<LoginBloc>(
      builder: (_, bloc) => bloc ?? LoginBloc(),
      onDispose: (_, bloc) => bloc?.dispose(),
      child: LoginScreen(),
    );
    return page;
  }

  void _onIsLoggedInData(AuthorizationModel model) {
    print('authmodel is $model');
    debug.printAuthorizationModel(model);
    if (model?.isAuthorized == true &&
        !(model?.isDefault == true)) {
      _bloc.storeStationList(model.stationList);

      _openPage(buildHomePage());
    } else {
      return _openPage(buildLoginPage());
    }
  }

  void _openPage(Widget page) {
    Navigator.pushReplacement(this.context,
        MaterialPageRoute(builder: (context) {
          return page;
        }));
  }


  void _onIsLoggedInError(Object error, StackTrace trace) {
  print('Handle onIsLoggedInError');
  print('Error is $error');
  print('Stacktrace is $trace');
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: LoadingCircular(
        message: 'Logging In',
      ),
    );
  }
}
