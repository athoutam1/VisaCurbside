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
          PendingOrderCard(Store(3, 'Costco')),
          Text("Ready for pickup:"),
          PickupOrderCard(Store(3, 'Costco')),
          Text("Past orders:"),
          PastOrderCard(Store(3, 'Costco')),
        ],
      ),
    );
  }
}
