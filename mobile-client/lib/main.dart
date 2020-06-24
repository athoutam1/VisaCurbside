import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import './authListener.dart';
import 'package:visa_curbside/services/auth.dart';
import './models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/dataStore.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String userString = (prefs.getString('user'));
  if (userString != null) {
    globalUser = User.fromJson(json.decode(userString));
  }
  runApp(MyApp(userString != null));
}

class MyApp extends StatelessWidget {
  final bool _isLoggedIn;
  MyApp(this._isLoggedIn);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: CupertinoApp(
        title: 'My App',
        theme: CupertinoThemeData(
          primaryColor: CupertinoColors.systemBlue,
        ),
        home: AuthListener(_isLoggedIn),
      ),
    );
  }
}

// Just an example widget we had to show HTTP requests example:

// class Sample extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Sample> {
//   String text = "";
//   int number = 0;

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//         navigationBar: CupertinoNavigationBar(
//           middle: Text("Sample App"),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: Text(
//                 text,
//                 style: TextStyle(fontSize: 25),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//               child: Text(
//                 "Random Number: ${number.toString()}",
//                 style: TextStyle(fontSize: 25),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             CupertinoButton(
//               child: Text("Tapped"),
//               padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
//               onPressed: () async {
//                 http.Response res =
//                     await http.get('http://localhost:3005/sampleData');
//                 setState(() {
//                   text = jsonDecode(res.body)["text"];
//                   number = jsonDecode(res.body)["number"];
//                 });
//                 print(jsonDecode(res.body));
//               },
//             ),
//             // CupertinoButton(
//             //   child: Text("go to next screen"),
//             //   onPressed: () {
//             //     Navigator.pushNamed(context, '/login');
//             //   },
//             // )
//           ],
//         ));
//   }
// }
