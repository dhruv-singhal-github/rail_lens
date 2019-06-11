import 'package:flutter/material.dart';

class Provider<B> extends InheritedWidget {
  static Type _getType<I>() => I;

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

  static H of<H>(BuildContext context) {
    final type = _getType<Provider<H>>();
    final Provider<H> provider = context.inheritFromWidgetOfExactType(type);
    if(provider == null)
      throw Exception('Provider was null! Ensure that you have a BlockProvider of the specified type in the ancestor tree of the widget');
    return provider.bloc;
  }
}

class BlocProvider<B> extends StatefulWidget {
  final void Function(BuildContext context, B bloc) onDispose;
  final B Function(BuildContext context, B bloc) builder;
  final Widget child;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.builder,
    @required this.onDispose,
  }) : super(key: key);


  @override
  _BlocProviderState<B> createState() {
    return _BlocProviderState();
  }
}

class _BlocProviderState<B> extends State<BlocProvider<B>> {

  B bloc;

  @override
  void initState() {
    if(widget.builder != null)
      bloc = widget.builder(context, bloc);
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
