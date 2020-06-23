// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'My App',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = "";
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Sample App"),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "Random Number: ${number.toString()}",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            CupertinoButton(
              child: Text("Tapped"),
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              onPressed: () async {
                http.Response res =
                    await http.get('http://localhost:3005/sampleData');
                setState(() {
                  text = jsonDecode(res.body)["text"];
                  number = jsonDecode(res.body)["number"];
                });
                print(jsonDecode(res.body));
              },
            )
          ],
        ));
  }
}
