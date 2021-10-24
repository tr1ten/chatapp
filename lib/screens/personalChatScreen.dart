import 'package:chatapp/widgets/personalmessages.dart';
import 'package:chatapp/widgets/sendPersonalMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonalChatScreen extends StatelessWidget {
  final DocumentSnapshot user;

  const PersonalChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: BackButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('/tabsScreen'),
        ),
        title: Text(user.get('username')),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PMessages(
                toUser: user,
              ),
            ),
            PNewMessage(
              userdoc: user,
            ),
          ],
        ),
      ),
    );
  }
}
