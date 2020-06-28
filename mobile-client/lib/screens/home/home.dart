import 'package:flutter/cupertino.dart';

import '../search/search.dart';
import '../order/order_page.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.create_solid),
            title: Text('Orders'),
          ),
        ],
        currentIndex: 0,
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return Search();
            break;
          case 1:
            return OrderPage();
            break;
        }
        return null;
      },
    );
  }
}
