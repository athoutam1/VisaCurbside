import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/dataStore.dart';
import 'package:visa_curbside/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Settings extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Settings"),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            CupertinoButton(
              color: CupertinoColors.destructiveRed,
              child: Text("Delete Account"),
              onPressed: () { 
                showAlertDialog(context);
                print("Delete Account Button Pressed");
              },
            ),
          ],
        ));
  }
  void showAlertDialog(BuildContext context) {
    
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Are you sure you want to delete your account?"),
        content: Text("This action is permanent"),
        actions: <Widget>[
          CupertinoButton(
            child: Text("Yes"),
            onPressed: () async {
              http.Response res =
                await http.post('http://localhost:3005/user/deleteUser', 
                  body: {'id': '${globalUser.uid}'});
              print('status code:  ${res.statusCode}');
              
              if (res.statusCode == 200) {
                _auth.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
                print("Account deleted by user"); 
              }
          }),
          CupertinoButton(
            child: Text("No"), 
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              print("Account not deleted by user");

            })
          
        ],
        )

    );
  }
}
