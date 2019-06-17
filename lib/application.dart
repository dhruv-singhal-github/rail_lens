import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'application_bloc.dart';
import 'bloc_provider.dart';
import 'consta.dart';
import 'login_screen.dart';
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
  ApplicationBloc bloc;
  //TODO: Replace StreamBuilder with custom stream logic
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<ApplicationBloc>(context).isLoggedIn,
      builder: (context, AsyncSnapshot<bool> snapshot) {
//        if (!snapshot.hasData) {
//          return LoadingPage();
//        } else if (snapshot.data) {
//          return showHomePage();
//        }
//        return showLoginPage();
          return showHomePage();
      },
    );
  }

  @override
  void didChangeDependencies() {
//    bloc = Provider.of<ApplicationBloc>(context);
    super.didChangeDependencies();
  }

  Widget showHomePage() {
//    final page = BlocProvider<HomePageBloc>(
//      builder: (_, bloc)=>bloc??HomePageBloc(),
//      onDispose: (_, bloc)=> bloc?.dispose(),
//      child: HomePageBloc(),
//    );
    return HomePage();
  }

  Widget showLoginPage() {
    final page = BlocProvider<LoginBloc>(
      builder: (_, bloc) => bloc ?? LoginBloc(),
      onDispose: (_, bloc) => bloc?.dispose(),
      child: LoginScreen(),
    );
    return page;
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
      body: LoadingCircular(message: 'Logging In',),
    );
  }
}
