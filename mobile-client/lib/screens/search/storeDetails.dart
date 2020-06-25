import 'package:flutter/cupertino.dart';
import '../../models/store.dart';
import './cart.dart';

class StoreDetails extends StatelessWidget {
  Store _store;
  StoreDetails(this._store);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_store.name),
        trailing: GestureDetector(
          child: Icon(CupertinoIcons.shopping_cart),
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Cart()));
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Welcome to the store page"),
        ],
      ),
    );
  }
}
