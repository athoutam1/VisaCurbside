import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/services/auth.dart';
import '../../models/dataStore.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Welcome to the home page. Here's your UID:"),
          Text(globalUser != null ? globalUser.uid : ""),
          Center(
            child: CupertinoButton.filled(
              child: Text("Log out"),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          )
        ],
      ),
    );
  }
}
