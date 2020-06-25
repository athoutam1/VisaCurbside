import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/store.dart';

class PickupOrderCard extends StatelessWidget {
  Store _store;
  PickupOrderCard(this._store);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(CupertinoIcons.check_mark_circled),
            title: Text(_store.name),
            subtitle: Text('Placed on 6/23 at 3:45PM'),
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
