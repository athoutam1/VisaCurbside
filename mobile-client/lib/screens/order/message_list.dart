import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:visa_curbside/models/message.dart';
import 'package:visa_curbside/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:visa_curbside/screens/order/message_tile.dart';
import 'package:http/http.dart' as http;

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  String _message = "";
  @override
  Widget build(BuildContext context) {
    List<Message> messages = Provider.of<List<Message>>(context) ?? [];
    return Column(
      children: <Widget>[
        Expanded(
          flex: 12,
          child: Container(
          color: Colors.grey[300],
          child: ListView.builder(
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
    );
      
  
  } 

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white ,
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoTextField(
              onSubmitted: (value) {
                setState(() {
                  _message = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          FlatButton(
            child: Text("send"),
            onPressed: () async {
                
                // Map<String, String> queryParameters = {
                //   "message": _message,
                //   "storeID": "1",
                //   "userID": "abc"
                // };
                // dynamic uri = Uri.https("localhost:3005", "/messageMerchant", queryParameters);
                // print(uri);
                // http.Response res =
                // await http.get(uri);
                // print(res.statusCode);
              print("send message");
              print(_message);
            },
          )
        ],
      ),
    );
  }
}
