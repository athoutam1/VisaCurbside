import 'package:flutter/cupertino.dart';
import '../settings/settings.dart';
import '../../models/store.dart';
import './storeDetails.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: "search screen",
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
          Text("Search for the stores you want to shop at. (Home Page)"),
          StoreCard(
            Store(1, "Publix"),
          ),
        ],
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  Store _store;
  StoreCard(this._store);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Text(_store.name),
      onPressed: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => StoreDetails(_store)));
      },
    );
  }
}
