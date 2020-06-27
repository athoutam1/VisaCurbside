import 'package:flutter/cupertino.dart';
import '../settings/settings.dart';
import './pendingOrder.dart';
import './pickupOrder.dart';
import './pastOrder.dart';
import '../../models/store.dart';

class Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: "order screen",
        transitionBetweenRoutes: false,
        middle: Text("Visa Curbside"),
        trailing: GestureDetector(
          child: Icon(CupertinoIcons.profile_circled),
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Settings()));
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Pending Orders:"),
          PendingOrderCard(Store(merchantID: "id123", merchantName: "costco123", storeID: 3, storeName: "Costco 1")),
          Text("Ready for pickup:"),
          PickupOrderCard(Store(merchantID: "id123", merchantName: "costco123", storeID: 3, storeName: "Costco 1")), 
          Text("Past orders:"),
          PastOrderCard(Store(merchantID: "id123", merchantName: "costco123", storeID: 3, storeName: "Costco 1")),
        ],
      ),
    );
  }
}
