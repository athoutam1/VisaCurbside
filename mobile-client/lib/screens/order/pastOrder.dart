import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/store.dart';

class PastOrderCard extends StatelessWidget {
  final Store _store;
  PastOrderCard(this._store);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(CupertinoIcons.restart),
            title: Text(_store.merchantName),
            subtitle: Text('Placed on 6/23 at 3:45PM'),
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
