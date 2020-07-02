import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/screens/order/map_page.dart';
import 'package:visa_curbside/screens/order/messageMerchant.dart';
import 'package:visa_curbside/screens/order/payNow.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/shared/constants.dart';
import '../../models/store.dart';
import 'package:visa_curbside/models/dataStore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

class PickupOrderCard extends StatelessWidget {
  Order _order;
  Store _store;
  PickupOrderCard(this._order);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kLightYellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: Icon(CupertinoIcons.check_mark_circled),
            title: Text(_order.storeName),
            subtitle:
                Text("Order ID: " + _order.id.toString() + "\n" + _order.time),
            onTap: () async {
              _store = await databaseHelper
                  .getStoreDetailsFromID(int.parse(_order.storeID));
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PickupOrder(_order, _store)));
            },
          ),
        ],
      ),
    );
  }
}

class PickupOrder extends StatefulWidget {
  Order _order;
  Store _store;
  PickupOrder(this._order, this._store);
  List<Item> _items;

  @override
  _PickupOrderState createState() => _PickupOrderState();
}

class _PickupOrderState extends State<PickupOrder> {
  List<Item> _items;
  GoogleMapController _mapController;
  static const LatLng _center = const LatLng(33.780546, -84.388945);
  LatLng _lastMapPosition = _center;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Order: " + widget._order.id.toString()),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: Text(
                    widget._store.storeName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                  child: Text(widget._store.location),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition:
                          CameraPosition(target: _center, zoom: 16.5),
                      onCameraMove: _onCameraMove,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      color: kVisaBlue,
                    ),
                    child: CupertinoButton(
                      child: Text("Message Merchant",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MessageMerchant(
                                    widget._store, globalUser.uid)));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      color: kVisaBlue,
                    ),
                    child: CupertinoButton(
                      child: Text("I am Here",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        var headers = {'Content-Type': 'application/json'};
                        String uri = 'http://localhost:3005/order/here';
                        dynamic data = {
                          "orderID": widget._order.id,
                          "coordinates": kPublixAtlanta
                        };

                        http.Response res = await http.post(uri,
                            headers: headers, body: jsonEncode(data));
                        print("I am here sent");
                        print('status code:  ${res.statusCode}');
                        _showIAmHereAlertDiago(context);
                      },
                    ),
                  ),
                ),
                Text(
                  "Order Summary",
                  style: kOrderHeadersTextStyle.copyWith(color: Colors.black),
                ),
                FutureBuilder<List<Item>>(
                    future:
                        databaseHelper.getItemsFromIDs(widget._order.itemIDs),
                    initialData: List(),
                    builder: (context, snapshot) {
                      widget._items = snapshot.data;
                      List<ItemCardStoreDetails> _cards = new List();
                      List<Text> _texts = new List();
                      for (int i = 0; i < widget._items.length; i++) {
                        _cards.add(ItemCardStoreDetails(widget._items[i]));
                        _texts.add(Text(widget._items[i].name));
                      }
                      return snapshot.hasData
                          ? Container(
                              height: 500,
                              child:
                                  ListView(shrinkWrap: false, children: _cards))
                          : Center(child: CircularProgressIndicator());
                    }),
              ],
            ),
          ),
        ));
  }
  void _showIAmHereAlertDiago(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context, 
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoAlertDialog(title: Text("Sending Your Coordinates"),),
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kVisaBlue),
              backgroundColor: kVisaGold,
            )
          ],
        ),
      )
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      }
      );
  }
}

class ItemCardStoreDetails extends StatelessWidget {
  final Item _item;

  ItemCardStoreDetails(this._item);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_item.name, style: TextStyle(fontWeight: FontWeight.bold)),
        isThreeLine: true,
        subtitle: Text(
            " ${_item.description}\n " + "\$" + _item.price.toString(),
            style: TextStyle(letterSpacing: 2)),
        onTap: () {},
      ),
    );
  }
}
