import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/shared/constants.dart';
import '../settings/settings.dart';
import 'package:visa_curbside/models/store.dart';
import './storeDetails.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

DatabaseHelper databaseHelper = new DatabaseHelper();

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchBarController<Store> _searchBarController = SearchBarController();
  bool isReplay = false;
  String _query = "";

  Future<List<Store>> _getStores(String search) async {
    List<Store> storesList = new List<Store>();
    http.Response res =
        await http.get('http://localhost:3005/merchant/search?query=' + search);
    List<dynamic> responses = jsonDecode(res.body);
    responses.forEach((element) {
      storesList.add(Store.fromMap(element));
    });
    return storesList;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: "search screen",
          transitionBetweenRoutes: false,
          middle: Text("Visa Curbside"),
        ),
        child: SafeArea(
          child: CupertinoPageScaffold(
              child: Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Discover Stores Near You",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        letterSpacing: 2.5)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      CupertinoIcons.location,
                      color: kVisaGold,
                    ),
                    Text("Atlanta, GA",
                        style: TextStyle(
                          color: kVisaGold,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 40,
                  width: 350,
                  child: CupertinoTextField(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.grey[300],
                    ),
                    cursorWidth: 3,
                    prefix: Icon(
                      CupertinoIcons.search,
                      color: Colors.black,
                    ),
                    autocorrect: false,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Distance",
                              style: TextStyle(color: CupertinoColors.black)),
                          color: Colors.blue[50],
                          onPressed: () {
                            print("Search filter button pressed");
                          }),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      width: 150,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Category",
                              style: TextStyle(color: CupertinoColors.black)),
                          color: Colors.grey[300],
                          onPressed: () {
                            print("Sort filter button pressed");
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Store>>(
                    future: databaseHelper.getStores(_query),
                    initialData: List(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (_, int position) {
                                    final store = snapshot.data[position];
                                    return StoreCard(store);
                                  }),
                            )
                          : Center(child: CircularProgressIndicator());
                    })
              ],
            ),
          )),
        ));
  }
}

class StoreCard extends StatelessWidget {
  Store _store;
  StoreCard(this._store);
  Image _icon;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Card(
        color: Colors.grey.shade200,
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(_store.merchantName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_store.storeName),
                    leading: SizedBox(
                      height: 60,
                      width: 60,
                      child: _store.logoURL != null ? Image.network(_store.logoURL) : Container(),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => StoreDetails(_store)));
                  }),
            ),
          ],
        ),
      ])),
    );
  }
}
