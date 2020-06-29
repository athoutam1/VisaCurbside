import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/shared/constants.dart';

class CustomOrderPage extends StatefulWidget {
  final List<int> _itemsInCart;
  CustomOrderPage(this._itemsInCart);

  @override
  _CustomOrderPageState createState() => _CustomOrderPageState();
}

class _CustomOrderPageState extends State<CustomOrderPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Add Custom Order"),
        
      ),
      child: SafeArea(
        child: CupertinoPageScaffold(
          child: Column(
            children: <Widget>[
              Text("ItemIDs in Cart: " + widget._itemsInCart.toString(), style: TextStyle(fontSize: 32)),
            ],
          ),
        )
    )
    );
  }
}