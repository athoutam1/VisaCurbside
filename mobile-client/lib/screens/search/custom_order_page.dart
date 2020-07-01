import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/shared/constants.dart';

class CustomOrderPage extends StatefulWidget {
  final List<int> _itemsInCart;
  CustomOrderPage(this._itemsInCart);

  @override
  _CustomOrderPageState createState() => _CustomOrderPageState();
}

class _CustomOrderPageState extends State<CustomOrderPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("VisaCurbside"),
        ),
        child: SafeArea(
            child: CupertinoPageScaffold(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    "Item Request",
                    style: kOrderHeadersTextStyle.copyWith(letterSpacing: 1.5, fontSize: 32),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Name:",
                        style: kTextFormHeadersStyle,
                      ),
                      Container(child: CupertinoTextField()),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Description:",
                        style: kTextFormHeadersStyle,
                      ),
                      Container(
                          height: 150,
                          child: CupertinoTextField(
                            maxLines: null,
                          )
                      ),
                       SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: CupertinoButton(
                          color: kVisaBlue,
                          child: Text("Request Item"),
                          onPressed: () {
                            print("Submite requested item pressed");
                          },
                        ),
                      )
                      
                      
                    ],
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
