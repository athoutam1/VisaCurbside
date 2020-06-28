import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/models/item.dart';

class ItemDetails extends StatelessWidget {
  Item _item;
  ItemDetails(this._item);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Item Details"),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_item.name,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4
                  )),
                ],
              ),
              SizedBox(height: 50,),
              Text("Item Details:")
            ],
          ),
        ));
  }
  
}