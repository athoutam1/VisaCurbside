import 'package:flutter/material.dart';
import 'package:visa_curbside/models/message.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    bool isUser = message.messenger == 'user' ? true : false;
    return Container(
      
      margin: isUser 
        ? EdgeInsets.only(top: 8, bottom: 8, left: 100)
        : EdgeInsets.only(top: 8, bottom: 8, right: 100),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: isUser
        ? Colors.green[200]
        : Colors.lightBlue[200],
        borderRadius: isUser
        ? BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15))
        : BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15))
      ),

      child: isUser 
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message.message)
        ],
      )
      : message.messenger == 'veronica'
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(message.messenger,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            Text(message.message)
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(message.messenger,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            Text(message.message)
          ],
        )
      
      
    );
  }
}