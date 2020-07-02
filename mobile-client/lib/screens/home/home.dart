import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/screens/settings/settings.dart';
import 'package:visa_curbside/shared/constants.dart';

import '../search/search.dart';
import '../order/order_page.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return CupertinoTabScaffold(
      
      tabBar: CupertinoTabBar(
        activeColor: kVisaGold,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.create_solid),
            title: Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            title: Text("Profile")
          )
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
          case 2:
            return Settings();
            break;
        }
        return null;
      },
    );
  }
}
