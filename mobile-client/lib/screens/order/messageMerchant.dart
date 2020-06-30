import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:visa_curbside/models/message.dart';
import 'package:visa_curbside/services/firestore_database.dart';
import 'package:visa_curbside/screens/order/message_list.dart';

class MessageMerchant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Message>>.value(
      value: FirestoreDatabaseService().messages,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Chat with Merchant"),
        ),
        child: MessageList(),
      ),
    );
  }
}
