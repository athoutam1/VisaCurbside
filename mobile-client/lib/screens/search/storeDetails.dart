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
        middle: Text("VisaCurbside"),
        trailing: GestureDetector(
          child: Icon(CupertinoIcons.shopping_cart),
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Cart()));
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100,),
                  Text(_store.merchantName,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold
                  ),),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
