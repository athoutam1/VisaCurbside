import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/dataStore.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/screens/search/storeDetails.dart';
import 'package:visa_curbside/screens/search/webview.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/shared/constants.dart';
import '../../models/store.dart';
import './messageMerchant.dart';
import './payNow.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:visa_curbside/screens/search/cart.dart';

class PendingOrderCard extends StatelessWidget {
  Order _order;
  Store _store;
  PendingOrderCard(this._order);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kLightBlue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: Icon(CupertinoIcons.clock),
            title: Text(_order.storeName),
            subtitle:
                Text("Order ID: " + _order.id.toString() + "\n" + _order.time),
            onTap: () async {
              _store = await databaseHelper
                  .getStoreDetailsFromID(int.parse(_order.storeID));
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PendingOrder(_order, _store)));
            },
          ),
        ],
      ),
    );
  }
}

class PendingOrder extends StatefulWidget {
  Order _order;
  Store _store;
  PendingOrder(this._order, this._store);
  bool _payNowInvalidTrigger = false;
  
  List<Item> _items;
  @override
  _PendingOrderState createState() => _PendingOrderState();
}

DatabaseHelper databaseHelper = new DatabaseHelper();

class _PendingOrderState extends State<PendingOrder> {
  
  @override
  Widget build(BuildContext context) {
    bool _canPayNow = widget._order.isPending == 1 && widget._order.isReadyForPickup == 1;
    
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Order: " + widget._order.id.toString()),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Order Summary",
                      style:
                          kOrderHeadersTextStyle.copyWith(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  FutureBuilder<List<Item>>(
                      future:
                          databaseHelper.getItemsFromIDs(widget._order.itemIDs),
                      initialData: List(),
                      builder: (context, snapshot) {
                        widget._items = snapshot.data;
                        List<ItemCardStoreDetails> _cards = new List();
                        List<Text> _texts = new List();
                        List<Row> _rows = new List();
                        for (int i = 0; i < widget._items.length; i++) {
                          _cards.add(ItemCardStoreDetails(widget._items[i]));
                          _texts.add(Text(widget._items[i].name));
                          _rows.add(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(widget._items[i].name,
                                      style:
                                          TextStyle(color: Colors.grey[800])),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      '\$' + widget._items[i].price.toString(),
                                      style:
                                          TextStyle(color: Colors.grey[800])),
                                )
                              ],
                            ),
                          );
                        }
                        // return snapshot.hasData
                        //     ? ConstrainedBox(
                        //         constraints: BoxConstraints(minHeight: 20),

                        //         child: Container(
                        //           color: Colors.grey.shade200,
                        //           height: 100,
                        //           child: ListView(
                        //             shrinkWrap: true,
                        //             children: _texts,
                        //           ),
                        //         ),
                        //       )
                        //     : Center(child: CircularProgressIndicator());
                        return snapshot.hasData
                            ? ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 20,
                                ),
                                child: Container(
                                  color: Colors.grey.shade100,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        color: Colors.grey.shade100,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: Column(
                                            children: _rows,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Divider(
                                        height: 4,
                                        indent: 30,
                                        endIndent: 30,
                                        color: Colors.grey[900],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Subtotal",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800])),
                                                  ),
                                                  Spacer(
                                                    flex: 3,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                        '\$' +
                                                            getTotal(widget
                                                                    ._items)
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800])),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Tax",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800])),
                                                  ),
                                                  Spacer(
                                                    flex: 3,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                        '\$' +
                                                            (getTotal(widget
                                                                        ._items) *
                                                                    0.1)
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800])),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      "Total",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[800],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Spacer(
                                                    flex: 3,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      '\$' +
                                                          ((getTotal(widget
                                                                          ._items) *
                                                                      0.1) +
                                                                  getTotal(widget
                                                                      ._items))
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[800],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Center(child: CircularProgressIndicator());
                      }),
                      SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Contact Info",
                        style: kOrderHeadersTextStyle.copyWith(
                            color: Colors.black)),
                  ),
                  SizedBox(height: 20,),
                  Card(
                    color: Colors.grey.shade100,
                    child: ListTile(
                      title: Text("Phone Number"),
                      subtitle: Text("423-237-1234"),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Checkout",
                        style: kOrderHeadersTextStyle.copyWith(
                            color: Colors.black)),
                  ),
                  SizedBox(height: 20,),
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
                  widget._payNowInvalidTrigger ? 
                   Text("Store Must Approve Your Order First!", style: TextStyle(color: Colors.red),)
                   : Text(""),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(200)),
                        color:  _canPayNow ? kVisaBlue : Colors.grey
                      ),
                      child: CupertinoButton(
                        child: Text("Pay Now",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                               widget._payNowInvalidTrigger = true;
                            });
                          if (_canPayNow) { 
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        WebView(widget._order, widget._items)));
                          } 
                        }
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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
