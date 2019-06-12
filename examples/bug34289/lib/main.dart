import 'package:flutter_web/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FrogColor<Color>(value: Colors.green, child: FrogColor1()),
          ],
        ),
      ),
    );
  }
}

class FrogColor1 extends StatelessWidget {
  FrogColor1();

  @override
  Widget build(BuildContext context) => Text(
        'Hello, World2',
        style: TextStyle(color: FrogColor.of<Color>(context)),
      );
}

/// Returns the type [T].
/// See https://stackoverflow.com/questions/52891537/how-to-get-generic-type
/// and https://github.com/dart-lang/sdk/issues/11923.
Type _typeOf<T>() => T;

class FrogColor<T> extends InheritedWidget {
  final T value;

  const FrogColor({
    Key key,
    @required this.value,
    @required Widget child,
  })  : assert(value != null),
        assert(child != null),
        super(key: key, child: child);

  static T of<T>(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_typeOf<FrogColor<T>>())
            as FrogColor<T>)
        .value;
  }

  @override
  bool updateShouldNotify(FrogColor old) => true;
}
