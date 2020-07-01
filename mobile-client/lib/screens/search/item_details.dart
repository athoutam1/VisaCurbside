import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:visa_curbside/shared/constants.dart';

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
              SizedBox(height: 25,),
              Container(
                height: 300,
                width: 300,
                child: _item.imageURL != "url" ?
                Image.network(_item.imageURL)
                : Image.network("https://safetyaustraliagroup.com.au/wp-content/uploads/2019/05/image-not-found.png")),
              SizedBox(height: 50,),
              Text("Item Details:", style: kOrderHeadersTextStyle),
              SizedBox(height: 25,),
              Text(_item.description),
              SizedBox(height: 25,),
              Text("Price:", style: kOrderHeadersTextStyle),
              SizedBox(height: 25,),
              Text("\$" + _item.price.toString())
            ],
          ),
        ));
  }
  
}