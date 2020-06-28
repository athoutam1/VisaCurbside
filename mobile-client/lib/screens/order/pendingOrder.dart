import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/screens/search/storeDetails.dart';
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
            leading: Icon(CupertinoIcons.clock),
            title: Text("Order ID: " + _order.id.toString()),
            subtitle: Text(_order.time),
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

class PendingOrder extends StatelessWidget {
  Order _order;
  PendingOrder(this._order);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Order: " + _order.id.toString()),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
        ));
  }
}
