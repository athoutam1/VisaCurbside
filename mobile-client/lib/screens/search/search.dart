import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import '../settings/settings.dart';
import 'package:visa_curbside/models/store.dart';
import './storeDetails.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var databaseHelper = new DatabaseHelper();

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
    http.Response res = await http.get('http://localhost:3005/merchant/search?query=' + search);
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
        trailing: GestureDetector(
          child: Icon(CupertinoIcons.profile_circled),
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Settings()));
          },
        ),
      ),
      child: SafeArea(
        child: CupertinoPageScaffold(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Search for Stores Near You",
                style: TextStyle(fontSize: 20),),
                SizedBox(height: 20,),
                CupertinoTextField(
                  cursorWidth: 3,
                  placeholder: "search",
                  autocorrect: false,
                  onChanged: (value) => setState(() => _query = value),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  CupertinoButton(
                    child: Text("Filter",
                    style: TextStyle(
                      color: CupertinoColors.black
                    )),
                    color: CupertinoColors.lightBackgroundGray,
                    onPressed: () {
                      print("Search filter button pressed");
                    }),
                    SizedBox(width: 20),
                  CupertinoButton(
                    child: Text("Sort",
                    style: TextStyle(
                      color: CupertinoColors.black
                    )),
                    color: CupertinoColors.lightBackgroundGray,
                    onPressed: () {
                      print("Sort filter button pressed");
                    })
                ],
              ),
              SizedBox(height: 20,),
              FutureBuilder<List<Store>>(
                future: _getStores(_query),
                initialData: List(),
                builder: (context, snapshot) {
                  return snapshot.hasData ?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int position) {
                      final store = snapshot.data[position];
                      return Card(
                        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                        color: CupertinoColors.quaternaryLabel,
                        child: ListTile(
                          title: Text(store.storeName),
                          //TODO: change subtitle to location
                          subtitle: Text(store.merchantID),
                          onTap: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) => StoreDetails(store)));
                          },
                          )
                      );
                    }
                  )
                : 
                Center(
                  child: CircularProgressIndicator()
                );
                }
              )
                    
              ],
            ),
          )
          ),
      )
    );
  }
}


class StoreCard extends StatelessWidget {
  Store _store;
  StoreCard(this._store);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Text(_store.merchantName),
      onPressed: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => StoreDetails(_store)));
      },
    );
  }
}
