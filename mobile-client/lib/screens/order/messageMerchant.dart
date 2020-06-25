import 'package:flutter/cupertino.dart';

class MessageMerchant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Message"),
      ),
      child: Text("Talking to merchant"),
    );
  }
}
