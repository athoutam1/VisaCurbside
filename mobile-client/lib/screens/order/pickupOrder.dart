import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/screens/order/map_page.dart';
import 'package:visa_curbside/screens/order/messageMerchant.dart';
import 'package:visa_curbside/screens/order/payNow.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/shared/constants.dart';
import '../../models/store.dart';
import 'package:visa_curbside/models/dataStore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

DatabaseHelper databaseHelper = new DatabaseHelper();
class PickupOrderCard extends StatelessWidget {
  Order _order;
  Store _store;
  PickupOrderCard(this._order);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: Icon(CupertinoIcons.check_mark_circled),
            title: Text(_order.storeName),
            subtitle: Text("Order ID: " + _order.id.toString() + "\n" + _order.time),
            onTap: () async {
               _store = await databaseHelper.getStoreDetailsFromID(int.parse(_order.storeID));
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PickupOrder(_order, _store)));
            }, 
          ),
        ],
      ),
    );
  }
}

class PickupOrder extends StatefulWidget {
  Order _order;
  Store _store;
  PickupOrder(this._order, this._store);

  List<Item> _items;
  @override
  _PickupOrderState createState() => _PickupOrderState();
}

class _PickupOrderState extends State<PickupOrder> {
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
                    child: Text("I am Here"),
                    onPressed: () async {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => MapPage()));
                        var headers = {'Content-Type': 'application/json'};
                        String uri = 'http://localhost:3005/order/here';
                        dynamic data = {
                          "orderID": widget._order.id,
                          "coordinates": kPublixAtlanta
                        };

                        http.Response res = await http.post(uri,
                            headers: headers, body: jsonEncode(data));
                        print("I am here sent");
                        print('status code:  ${res.statusCode}');
                        print(widget._order.isPending);
                        print(widget._order.isReadyForPickup);
                   

                    },
              ),
                ),
              
            ],
          ),
        ));
  }
}