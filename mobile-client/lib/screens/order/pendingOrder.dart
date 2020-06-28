import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/screens/search/storeDetails.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import '../../models/store.dart';
import './messageMerchant.dart';
import './payNow.dart';

class PendingOrderCard extends StatelessWidget {
  Order _order;
  PendingOrderCard(this._order);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: Icon(CupertinoIcons.clock),
            title: Text(_order.storeName),
            subtitle: Text("Order ID: " + _order.id.toString() + "\n" + _order.time),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PendingOrder(_order)));
            },
          ),
        ],
      ),
    );
  }
}

class PendingOrder extends StatefulWidget {
  Order _order;
  PendingOrder(this._order);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Store>(
                future: databaseHelper.getStoreDetailsFromID(int.parse(widget._order.storeID)),
                initialData: Store(),
                builder: (context, snapshot) {
                Store store = snapshot.data;
                return snapshot.hasData ?
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text("Store Info:"),
                          Text(store.merchantName),
                          Text(store.description),
                          Text(store.location),
                          Text("Items:"),
                          Text(widget._order.itemIDs.toString()),
                          Text("Total:"),
                          Text("\$ " + widget._order.total.toString()),
                          CupertinoButton(
                            child: Text("Message Merchant"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MessageMerchant()));
                            },
                          ),
                        CupertinoButton(
                          child: Text("Pay Now"),
                          onPressed: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) => PayNow()));
                          },
                        ),
                        ],
                      ),
                    ],
                  ),
                )
                : 
                Center(
                  child: CircularProgressIndicator()
                );
                }
              ),
            
          ],
        ));
  }
}

