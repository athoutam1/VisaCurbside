import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/order.dart';
import '../../models/store.dart';

class PastOrderCard extends StatelessWidget {
  final Order _order;
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
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PastOrder()));
            },
          ),
        ],
      ),
    );
  }
}

class PastOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Order #12312312"),
      ),
      child: Text("Sup"),
    );
  }
}
