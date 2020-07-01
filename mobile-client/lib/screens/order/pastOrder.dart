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