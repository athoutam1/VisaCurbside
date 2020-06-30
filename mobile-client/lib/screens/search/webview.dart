import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/dataStore.dart';
import 'package:visa_curbside/models/store.dart';
import 'package:visa_curbside/models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class WebView extends StatefulWidget {
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
              callback: (args) {
                // here
                // showConfirmOrderAlertDialog(context, widget._itemsInCart,
                //     widget._itemIDsInCart, widget._store);
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

void showConfirmOrderAlertDialog(BuildContext context, List<Item> itemsInCart,
    List<int> itemIDsinCart, Store store) {
  showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Are you ready to submit your order?"),
        content: Text("Total: \$ " + getTotal(itemsInCart).toString()),
        actions: <Widget>[
          CupertinoButton(
            child: Text("Submit"),
            onPressed: () async {
              if (itemIDsinCart.length != 0) {
                var headers = {'Content-Type': 'application/json'};
                String uri = 'http://localhost:3005/merchant/confirmOrder';
                dynamic data = {
                  "storeID": store.storeID,
                  "itemIDs": itemIDsinCart,
                  "userID": globalUser.uid.toString()
                };

                http.Response res = await http.post(uri,
                    headers: headers, body: jsonEncode(data));

                print('status code:  ${res.statusCode}');

                print("submit button clicked");
              } else {
                print("Order cannot be empty");
              }

              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          CupertinoButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                print("cancel submit order");
              })
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
