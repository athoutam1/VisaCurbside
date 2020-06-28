import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/order.dart';
import '../../models/store.dart';

class PickupOrderCard extends StatelessWidget {
  Order _order;
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
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PickupOrder()));
            },
          ),
        ],
      ),
    );
  }
}

class PickupOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Order #12312312"),
        ),
        child: Center(
          child: CupertinoButton(
            child: Text("I'm here"),
            onPressed: () {},
          ),
        ));
  }
}
