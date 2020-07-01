import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/dataStore.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/models/store.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:visa_curbside/shared/constants.dart';

class WebView extends StatefulWidget {
  Order _order;
  List<Item> _itemsInCart;
  WebView(this._order, this._itemsInCart);
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: InAppWebView(
        initialUrl: "https://33f9240848dd.ngrok.io",
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            debuggingEnabled: true,
          ),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;

          controller.addJavaScriptHandler(
              handlerName: "success",
              callback: (args) async {

                var headers = {'Content-Type': 'application/json'};
                String uri = 'http://localhost:3005/merchant/changeOrderStatus';
                dynamic data = {
                  "orderID": widget._order.id,
                  "isPending" : false, 
                  "isReadyForPickup": true,
                };

                http.Response res = await http.post(uri,
                    headers: headers, body: jsonEncode(data));
                print("order paid for");
                print('status code:  ${res.statusCode}');
                print(widget._order.isPending);
                print(widget._order.isReadyForPickup);
                showOrderPaidForAlertDialog(context, widget._order, widget._itemsInCart);

               

              });
        },
        onLoadStart: (InAppWebViewController controller, String url) {
          setState(() {
            this.url = url;
          });
        },
        onLoadStop: (InAppWebViewController controller, String url) async {
          setState(() {
            this.url = url;
          });
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
      ),
    );
  }
}

void showOrderPaidForAlertDialog(BuildContext context, Order _order, List<Item> _itemsInCart) {
  showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Your order has been submitted!"),
        content: Text(
          "Total: \$ " + getTotal(_itemsInCart).toString(),
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text("Thanks!"),
            onPressed: () async {

              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ));
}

double getTotal(List<Item> itemsInCart) {
  if (itemsInCart == null) {
    return 0;
  }
  double total = 0;
  itemsInCart.forEach((element) {
    total += element.price;
  });
  double mod = pow(10.0, 2);
  return ((total * mod).round().toDouble() / mod);
}
