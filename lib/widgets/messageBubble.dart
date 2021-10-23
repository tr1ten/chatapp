// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String userImage;
  MessageBubble(this.message, this.isMe, this.userName, this.userImage,
      {required this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // Text(userName,style: TextStyle(fontWeight: FontWeight.bold),
            //     textAlign: isMe? TextAlign.end : TextAlign.start,
            //     ),
            Container(
              width: 150,
              decoration: BoxDecoration(
                color: isMe ? Colors.teal[700] : Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1.0)),
                      textAlign: TextAlign.start,
                    ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.white),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isMe)
          Positioned(
            child: CircleAvatar(
              backgroundImage: AssetImage("asserts/images/dp.png"),
              foregroundImage: NetworkImage(userImage),
              radius: 23,
            ),
            left: 120,
            top: -9,
          )
      ],
      // overflow: Overflow.visible,
      clipBehavior: Clip.none,
    );
  }
}
