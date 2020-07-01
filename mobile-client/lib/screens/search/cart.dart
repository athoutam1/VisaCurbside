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
import 'package:visa_curbside/shared/constants.dart';
import 'dart:convert';

import './webview.dart';

var databaseHelper = new DatabaseHelper();

class Cart extends StatefulWidget {
  List<int> _itemIDsInCart;
  double _total;
  Store _store;
  Cart(this._itemIDsInCart, this._total, this._store);
  List<Item> _itemsInCart;
  Map<Item, int> _itemQuantities = new HashMap();

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  void _generateItemFrequency() {
    widget._itemQuantities = new HashMap();
    widget._itemsInCart.forEach((element) {
      if (widget._itemQuantities.containsKey(element)) {
        widget._itemQuantities[element] = widget._itemQuantities[element] + 1;
      } else {
        widget._itemQuantities[element] = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Cart", style: TextStyle(fontSize: 24, letterSpacing: 3)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
              child: Text(
                "\$" + widget._total.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
            FutureBuilder<List<Item>>(
                future: databaseHelper.getItemsFromIDs(widget._itemIDsInCart),
                initialData: List(),
                builder: (context, snapshot) {
                  widget._itemsInCart = snapshot.data;
                  _generateItemFrequency();
                  List<ItemCard> _cards = new List();
                  List<Item> keys = widget._itemQuantities.keys.toList();
                  List<int> values = widget._itemQuantities.values.toList();
                  for (int i = 0; i < widget._itemQuantities.length; i++) {
                    _cards.add(
                        ItemCard(keys[i], values[i], widget._itemIDsInCart));
                  }
                  return snapshot.hasData
                      ? Container(
                          height: 525,
                          child: ListView(
                            shrinkWrap: true,
                            children: _cards,
                          ))
                      : Center(child: CircularProgressIndicator());
                }),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(200)),
                color: kVisaBlue,
              ),
              child: CupertinoButton(
                child: Text("Confirm Order", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  showConfirmOrderAlertDialog(context, widget._itemsInCart,
                      widget._itemIDsInCart, widget._store);
                  // Navigator.push(
                  //     context, CupertinoPageRoute(builder: (context) => WebView(widget._itemsInCart, widget._itemIDsInCart, widget._store)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showConfirmOrderAlertDialog(BuildContext context, List<Item> itemsInCart,
      List<int> itemIDsinCart, Store store) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text("Send Order to Store?"),
          content: Text(
            "Total: \$ " + getTotal(itemsInCart).toStringAsFixed(2),
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text("Yes"),
              onPressed: () async {
                if (widget._itemIDsInCart.length != 0) {
                  var headers = {'Content-Type': 'application/json'};
                  String uri = 'http://localhost:3005/merchant/confirmOrder';
                  dynamic data = {
                    "storeID": widget._store.storeID,
                    "itemIDs": widget._itemIDsInCart,
                    "userID": globalUser.uid.toString(),
                  };
                  http.Response res = await http.post(uri,
                      headers: headers, body: jsonEncode(data));
                  print('status code:  ${res.statusCode}');
                  print("submit button clicked");
                } else {
                  print("Order cannot be empty");
                }
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            CupertinoButton(
              child: Text("No"),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ));
  }
}

class ItemCard extends StatefulWidget {
  final Item _item;
  final int _quantity;
  List<int> _itemIDsInCart;
  ItemCard(this._item, this._quantity, this._itemIDsInCart);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: ListTile(
                  title: Text(widget._item.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  isThreeLine: true,
                  subtitle: Text(
                      " ${widget._item.description}\n " +
                          "\$" +
                          widget._item.price.toString(),
                      style: TextStyle(letterSpacing: 2)),
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ItemDetails(widget._item)));
                    print("clicked" + widget._item.name);
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    color: kVisaGold,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text(
                          "-",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // setState(() {
                          //widget._itemIDsInCart.remove(widget._item.id);
                          // });
                          print("minus 1");
                        },
                      ),
                      Text(
                        "${widget._quantity}",
                        style: TextStyle(color: Colors.white),
                      ),
                      CupertinoButton(
                        child: Text(
                          "+",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // setState(() {
                          //   widget._itemIDsInCart.add(widget._item.id);
                          // });
                          print(widget._itemIDsInCart);
                          print("add 1");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
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
