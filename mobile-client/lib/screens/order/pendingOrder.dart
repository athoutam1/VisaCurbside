import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/store.dart';
import './messageMerchant.dart';
import './payNow.dart';

class PendingOrderCard extends StatelessWidget {
  Store _store;
  PendingOrderCard(this._store);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(CupertinoIcons.clock),
            title: Text(_store.merchantName),
            subtitle: Text('Placed on 6/23 at 3:45PM'),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PendingOrder()));
            },
          ),
        ],
      ),
    );
  }
}

class PendingOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Order #12312312"),
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
