import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/screens/order/messageMerchant.dart';
import 'package:visa_curbside/screens/order/payNow.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/shared/constants.dart';
import '../../models/store.dart';
import 'package:visa_curbside/models/dataStore.dart';
 
 DatabaseHelper databaseHelper = new DatabaseHelper();
class PastOrderCard extends StatelessWidget {
  Store _store;
  Order _order;
  PastOrderCard(this._order);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: Icon(CupertinoIcons.restart),
            title: Text(_order.storeName),
            subtitle: Text("Order ID: " + _order.id.toString() + "\n" + _order.time),
            onTap: () async {
               _store = await databaseHelper.getStoreDetailsFromID(int.parse(_order.storeID));
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PastOrder(_order, _store)));
            },
          ),
        ],
      ),
    );
  }
}

class PastOrder extends StatefulWidget {
  Order _order;
  Store _store;
  PastOrder(this._order, this._store);

  List<Item> _items;
  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  List<Item> _items;

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
            ],
          ),
        ));
  }
}