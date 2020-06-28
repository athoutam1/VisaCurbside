import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/dataStore.dart';
import 'package:visa_curbside/models/store.dart';
import 'package:visa_curbside/screens/search/item_details.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


var databaseHelper = new DatabaseHelper();

class Cart extends StatefulWidget {
  List<int> _itemIDsInCart;
  double _total;
  Store _store;
  Cart(this._itemIDsInCart, this._total, this._store);

  List<Item> _itemsInCart;
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
        SizedBox(height: 25,),
        Text("\$" + widget._total.toString(),
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: 3
        )),
        FutureBuilder<List<Item>>(
                future: databaseHelper.getItemsFromIDs(widget._itemIDsInCart),
                initialData: List(),
                builder: (context, snapshot) {
                  widget._itemsInCart = snapshot.data;
                  return snapshot.hasData ?
                  Container(
                    height: 600,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, int position) {
                        final item = snapshot.data[position];
                        return ItemCard(item);
                      }
                    ),
                  )
                : 
                Center(
                  child: CircularProgressIndicator()
                );
                }
              ),
              SizedBox(height: 25,),

              CupertinoButton.filled(
                child: Text("Confirm Order"),
                onPressed: () {
                  showConfirmOrderAlertDialog(context, widget._itemsInCart, widget._itemIDsInCart, widget._store);
                },
              ),
      ],
    ),
  );
  }
}
double getTotal(List<Item>itemsInCart) {
  if (itemsInCart == null) {
    return 0;
  }
    double total = 0;
    itemsInCart.forEach((element) {
      total += element.price;
    });
    double mod = pow(10.0, 2);
    return ((total * mod).round().toDouble() / mod);
  }

void showConfirmOrderAlertDialog(BuildContext context, List<Item> itemsInCart, List<int> itemIDsinCart, Store store) {

  showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Are you ready to submit your order?"),
        content: Text("Total: \$ " + getTotal(itemsInCart).toString()),
        actions: <Widget>[
          CupertinoButton(
              child: Text("Submit"),
              onPressed: () async {
                var headers = {'Content-Type': 'application/json'};
                String uri = 'http://localhost:3005/merchant/confirmOrder';
                 dynamic data = {
                  "storeID": store.storeID,
                  "itemIDs": itemIDsinCart,
                  "userID" : globalUser.uid.toString()
                 };
                 print(data);
                
                http.Response res =
                await http.post(uri, headers: headers,body: jsonEncode(data));

                print('status code:  ${res.statusCode}');

                print("submit button clicked");
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
          ),
          CupertinoButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              print("cancel submit order");
            })
        ],
      ));
}

class ItemCard extends StatelessWidget {
  final Item _item;
  ItemCard(this._item);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text(_item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )),
                    isThreeLine: true,
                    subtitle: Text(" ${_item.description}\n " + "\$" + _item.price.toString(),
                    style: TextStyle(letterSpacing: 2)),
                    onTap: () {
                      Navigator.push(
                context, CupertinoPageRoute(builder: (context) => ItemDetails(_item)));
                      print("clicked" + _item.name);
                    },
                  ),
                ),
                Expanded(
                  flex:1, 
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    selected: true,
                    leading: Icon(Icons.edit),
                    onTap: () {
                      
                    },
                  ),
                )
                
              ],
            )
            ],
          ),
    );
  }
}

// class ItemCard extends StatelessWidget {
//   final Item _item;
//   ItemCard(this._item);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: <Widget>[
//             ListTile(
//               title: Text(_item.name,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold
//               )),
//               isThreeLine: true,
//               subtitle: Text(" ${_item.description}\n " + "\$" + _item.price.toString(),
//               style: TextStyle(letterSpacing: 2)),
//               onTap: () {
//                 print("clicked" + _item.name);
//               },
//               )
//             ],
//           ),
//     );
//   }
// }
