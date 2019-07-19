import 'dart:async';
import 'package:flutter/material.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CountTime _countTime;
  VoidCallback onclick;


  @override
  void initState() {
    _countTime = CountTime(maxSecond: 60);
    onclick = (){
      _countTime.startCount();
    };
    super.initState();
  }
  @override
  void dispose() {
    _countTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: _countTime.countTimeStream,
                initialData: 0,
                builder: (context, snap) {
                  var buttonText;
                  if (snap.data == 0) {
                    onclick = (){
                      _countTime.startCount();
                    };
                    buttonText = '发送验证码';
                  }else {
                    onclick = null;
                    buttonText = '${snap.data} 秒后可以再次发送';
                  }
                  return FlatButton(
                    onPressed: onclick,
                    child: Text(buttonText),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.white30,
                  );
                }
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class CountTime {
  StreamController<int> _controller;
  final int maxSecond;

  CountTime({this.maxSecond = 60}){
    _controller = StreamController();
  }

  Stream<int> get countTimeStream => _controller.stream;

  ///
  /// 开始倒计时
  ///
  startCount() async {
    if (maxSecond <= 0) {
      return;
    }
    for(var i = maxSecond; i >= 0; i--){
      Duration duration;
      if (i == maxSecond) {
        duration = Duration(seconds: 0);
      }else {
        duration = Duration(seconds: 1);
      }
      await Future.delayed(duration, (){
        return i;
      }).then((s){
        _controller.sink.add(s);
      });
    }
  }

  dispose() {
    _controller.close();
  }

}