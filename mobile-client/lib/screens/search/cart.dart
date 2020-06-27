import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/models/item.dart';

var databaseHelper = new DatabaseHelper();

class Cart extends StatefulWidget {
  final List<int> _itemsInCart;
  Cart(this._itemsInCart);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Cart",
        style: TextStyle(
          fontSize: 24,
          letterSpacing: 3
        )),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoButton(
            child: Text("testing"), 
            onPressed: () {
              List<Item> items = databaseHelper.getItemsForCartFromList(widget._itemsInCart);
              print(items);
            }
          ),
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
