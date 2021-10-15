import 'package:chatapp/widgets/newMessage.dart';
import 'package:flutter/material.dart';

class PersonalChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/messageScreen'),
        ),
        title: Text('UserName'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Container(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}