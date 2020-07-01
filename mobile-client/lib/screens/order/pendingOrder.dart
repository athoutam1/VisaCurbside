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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget._store.storeName, 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                  ),),
              Text(widget._store.location),
              SizedBox(height: 50,),
              Text("Cart Details", style: kOrderHeadersTextStyle.copyWith(color: Colors.black),),
              FutureBuilder<List<Item>>(
                  future: databaseHelper.getItemsFromIDs(widget._order.itemIDs),
                  initialData: List(),
                  builder: (context, snapshot) {
                  widget._items = snapshot.data;
                  return snapshot.hasData ?
                  Container(
                      child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget._items.length,
                      itemBuilder: (_, int position) {
                        return Card(
                          child: Text(widget._items[position].name),
                        );
                      }),
                  )
                  : 
                  Center(
                    child: CircularProgressIndicator()
                  );
                  }
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                    color: kVisaBlue,
                    child: Text("Message Merchant"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MessageMerchant(widget._store, globalUser.uid)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                    color: kVisaBlue,
                    child: Text("Pay Now"), 
                    onPressed: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => WebView(widget._order, widget._items)));
                  },
              ),
                ),
              
            ],
          ),
        ));
  }
}

