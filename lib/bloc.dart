import 'dart:async';
import 'package:flutter/material.dart';

import 'package:rail_lens/validator.dart';
import 'package:rxdart/rxdart.dart';

Type _getType<B>() => B;

class LoginBloc extends Object with Validator implements BaseBloc {
  final _usernameController = PublishSubject<String>();
  final _passwordController = PublishSubject<String>();

  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck =>
      Observable.combineLatest2(username, password, (u, p) {
        print('username was was $u and password was $p');
        return true;
      });

  Function(String) get usernameChanged => _usernameController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
  }
}

class NetworkBloc implements BaseBloc {
  @override
  void dispose() {
    //dispose
  }
}

class Provider<B> extends InheritedWidget {
  final B bloc;

  const Provider({
    Key key,
    this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(Provider<B> oldWidget) {
    return bloc != oldWidget.bloc;
  }

  static B of<B>(BuildContext context) {
    final type = _getType<Provider<B>>();
    final Provider<B> provider = context.inheritFromWidgetOfExactType(type);

    return provider.bloc;
  }
}

class BlockProvider<B> extends StatefulWidget {
  final void Function(BuildContext context, B bloc) onDispose;
  final B Function(BuildContext context, B bloc) builder;
  final Widget child;

  BlockProvider({
    Key key,
    @required this.child,
    @required this.builder,
    @required this.onDispose,
  }) : super(key: key);



  @override
  _BlockProviderState createState() {
    return _BlockProviderState();
  }
}

class _BlockProviderState<B> extends State<BlockProvider<B>> {

  B bloc;


  @override
  void initState() {
    if(widget.builder != null){
      widget.builder(context, bloc);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      bloc: bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    if(widget.onDispose != null){
      widget.onDispose(context, bloc);
    }
    super.dispose();
  }


}

abstract class BaseBloc {
  void dispose();
}
