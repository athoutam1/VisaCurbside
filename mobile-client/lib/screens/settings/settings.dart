import 'package:flutter/cupertino.dart';
import '../../models/dataStore.dart';
import 'package:visa_curbside/services/auth.dart';

class Settings extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Settings"),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(globalUser != null ? globalUser.uid : ""),
            Center(
              child: CupertinoButton.filled(
                child: Text("Log out"),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
            CupertinoButton.filled(
              child: Text("Delete Account"),
              onPressed: () {
                print("Delete Account");
              },
            ),
          ],
        ));
  }
}
