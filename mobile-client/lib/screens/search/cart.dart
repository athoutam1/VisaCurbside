import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Cart"),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("All your shopping items"),
          Text("All your shopping items"),
          Text("All your shopping items"),
          CupertinoButton.filled(
            child: Text("Confirm Order"),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Order Confirmed!"),
        content: Text(
            "Thanks for shopping. View the status of your order in the orders tab while the merchant approves your list."),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("Dismiss")),
        ],
      ));
}
