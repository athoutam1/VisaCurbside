import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/dataStore.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/screens/search/storeDetails.dart';
import 'package:visa_curbside/screens/search/webview.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/shared/constants.dart';
import '../../models/store.dart';
import './messageMerchant.dart';
import './payNow.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:visa_curbside/screens/search/cart.dart';

class PendingOrderCard extends StatelessWidget {
  Order _order;
  Store _store;
  PendingOrderCard(this._order);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kLightBlue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: Icon(CupertinoIcons.clock),
            title: Text(_order.storeName),
            subtitle: Text("Order ID: " + _order.id.toString() + "\n" + _order.time),
            onTap: () async {
              _store = await databaseHelper.getStoreDetailsFromID(int.parse(_order.storeID));
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PendingOrder(_order, _store)));
            },
          ),
        ],
      ),
    );
  }
}

class PendingOrder extends StatefulWidget {
  Order _order;
  Store _store;
  PendingOrder(this._order, this._store);

  List<Item> _items;
  @override
  _PendingOrderState createState() => _PendingOrderState();
}

DatabaseHelper databaseHelper = new DatabaseHelper();

class _PendingOrderState extends State<PendingOrder> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Order: " + widget._order.id.toString()),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: Text(widget._store.storeName, 
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                      ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                  child: Text(widget._store.location),
                ),
                SizedBox(height: 25,),
                Text("Cart Details", style: kOrderHeadersTextStyle.copyWith(color: Colors.black),),
                FutureBuilder<List<Item>>(
                    future: databaseHelper.getItemsFromIDs(widget._order.itemIDs),
                    initialData: List(),
                    builder: (context, snapshot) {
                    widget._items = snapshot.data;
                    List<ItemCardStoreDetails> _cards = new List();
                  List<Text> _texts = new List();
                  for (int i = 0; i < widget._items.length; i++) {
                    _cards.add(ItemCardStoreDetails(widget._items[i]));
                    _texts.add(Text(widget._items[i].name));
                  }
                  return snapshot.hasData ?
                  Container(
                    height: 500,
                      child: ListView(
                      shrinkWrap: false,
                      children: _cards
                      )
                  )
                  :  
                    Center(
                      child: CircularProgressIndicator()
                    );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      color: kVisaBlue,),
                      child: CupertinoButton(
                        child: Text("Message Merchant", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => MessageMerchant(widget._store, globalUser.uid)));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      color: kVisaBlue,),
                      child: CupertinoButton(
                        child: Text("Pay Now", style: TextStyle(color: Colors.white)), 
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => WebView(widget._order, widget._items)));
                      },
                ),
                    ),
                  ),
                
              ],
            ),
          ),
        ));
  }
}
class ItemCardStoreDetails extends StatelessWidget {
  final Item _item;
 
  ItemCardStoreDetails(this._item);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_item.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        isThreeLine: true,
        subtitle: Text(
            " ${_item.description}\n " +
                "\$" +
                _item.price.toString(),
            style: TextStyle(letterSpacing: 2)),
        onTap: () {

        },
      ),
    );
  }
}

