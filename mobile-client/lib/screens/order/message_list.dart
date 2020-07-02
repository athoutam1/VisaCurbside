import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visa_curbside/models/message.dart';
import 'package:visa_curbside/models/store.dart';
import 'package:visa_curbside/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/screens/order/message_tile.dart';
import 'package:http/http.dart' as http;

class MessageList extends StatefulWidget {
  final Store _store;
  final String _uid;
  MessageList(this._store, this._uid);
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  String _message = "";

  @override
  Widget build(BuildContext context) {

    List<Message> messages = Provider.of<List<Message>>(context) ?? [];
    ScrollController _scrollController = new ScrollController();
    return  GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 12,
            child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageTile(messages[index]);
              }),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildMessageComposer(),
          )
          
        ],
      ),
    );

  } 

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      color: Colors.white ,
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
              placeholder: "Send message to merchant...",
              style: TextStyle(fontSize: 22),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) async {
                setState(() {
                    _message = value;
                  });
                  if (_message != "") {
                    Map<String, String> queryParameters = {
                    "message": _message,
                    "storeID": widget._store.storeID.toString(),
                    "userID": widget._uid
                    };
                    dynamic uri = Uri.http("localhost:3005", "/messageMerchant", queryParameters);
                    print(uri);
                    http.Response res =
                    await http.get(uri);
                    print(res.statusCode);
                    print("send message");
                    print(_message);
                  }

                },
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          CupertinoButton(
            child: Icon(Icons.send),
            onPressed: () async {
              
              if (_message != "") {
                Map<String, String> queryParameters = {
                  "message": _message,
                  "storeID": widget._store.storeID.toString(),
                  "userID": widget._uid
                };
                dynamic uri = Uri.http("localhost:3005", "/messageMerchant", queryParameters);
                print(uri);
                http.Response res =
                await http.get(uri);
                print(res.statusCode);
                print("send message");
                print(_message);
              }
              //_controller.clear();
            },
          )
        ],
      ),
    );
  }
}
