import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PayNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Payment"),
      ),
      child: Center(
        child: CupertinoButton(
          child: Text("Confirm Payment"),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Thank you!"),
        content:
            Text("Keep an eye on your order. It'll be ready for pickup soon."),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("Okay")),
        ],
      ));
}
