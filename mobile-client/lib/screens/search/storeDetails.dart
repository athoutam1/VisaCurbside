import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/screens/search/item_details.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import '../../models/store.dart';
import 'package:visa_curbside/models/item.dart';
import './cart.dart';


var databaseHelper = new DatabaseHelper();

class StoreDetails extends StatefulWidget {
  final Store _store;
  StoreDetails(this._store);

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  List<int> _itemsInCart = new List();
  double _total = 0;
  String _query = "";

  @override
  Widget build(BuildContext context) {
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("VisaCurbside"),
        trailing: GestureDetector(
          child: Icon(CupertinoIcons.shopping_cart),
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Cart(_itemsInCart, _total, widget._store)));
          },
        ),
      ),
      child: SafeArea(
        child: CupertinoPageScaffold(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(widget._store.merchantName,
                  style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
                SizedBox(height: 25),
                CupertinoTextField(
                  cursorWidth: 3,
                  placeholder: "search",
                  autocorrect: false,
                  onChanged: (value) => setState(() => _query = value),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  CupertinoButton(
                    child: Text("Filter",
                    style: TextStyle(
                      color: CupertinoColors.black
                    )),
                    color: CupertinoColors.lightBackgroundGray,
                    onPressed: () {
                      print("Search filter button pressed");
                    }),
                    SizedBox(width: 20),
                  CupertinoButton(
                    child: Text("Sort",
                    style: TextStyle(
                      color: CupertinoColors.black
                    )),
                    color: CupertinoColors.lightBackgroundGray,
                    onPressed: () {
                      print(_itemsInCart);
                      print("Sort filter button pressed");
                    })
                ],
              ),
              SizedBox(height: 20,),
              FutureBuilder<List<Item>>(
                future: databaseHelper.getItems(_query, widget._store.storeID),
                initialData: List(),
                builder: (context, snapshot) {
                  return snapshot.hasData ?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int position) {
                      final item = snapshot.data[position];
                      return ItemCard(item, showAddToCartDialog);
                    }
                  )
                : 
                Center(
                  child: CircularProgressIndicator()
                );
                }
              )
                    
              ],
            ),
          )
          ),
      ),
    );
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

  void showAddToCartDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text(item.name + ": \$" + item.price.toString(),
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 2,

        )),
        content: Text("Add this item to the cart?",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),),
        actions: <Widget>[
          CupertinoButton(
            child: Text("Yes"),
          onPressed: () {
            _itemsInCart.add(item.id);
            List<Item> temp = List();
            temp.add(item);
            _total += getTotal(temp);
            Navigator.of(context, rootNavigator: true).pop();
            print("yes add to cart");
          }),
          CupertinoButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              print("dont add to cart");
            })
        ],
      )
    );
  }
  
  
}

class ItemCard extends StatelessWidget {
  final Item _item;
  final Function _showAddToCartDialog;
  ItemCard(this._item, this._showAddToCartDialog);
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
                    leading: Icon(Icons.add),
                    onTap: () {
                      _showAddToCartDialog(context, _item);
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
