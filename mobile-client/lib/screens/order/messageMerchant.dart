import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:visa_curbside/models/message.dart';
import 'package:visa_curbside/models/store.dart';
import 'package:visa_curbside/services/firestore_database.dart';
import 'package:visa_curbside/screens/order/message_list.dart';

class MessageMerchant extends StatelessWidget {
  final Store _store;
  final String _uid;
  MessageMerchant(this._store, this._uid);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Message>>.value(
      value: FirestoreDatabaseService().getMessagesFroUserIDAndStoreID(_uid, _store.storeID.toString()),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Chat with Merchant"),
        ),
        child: MessageList(_store, _uid),
      )
      
    );
  }
}
