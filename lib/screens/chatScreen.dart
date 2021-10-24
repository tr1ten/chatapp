import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/widgets/drawer.dart';
import 'package:chatapp/widgets/messages.dart';
import 'package:chatapp/widgets/newMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  // final CollectionReference data = FirebaseFirestore.instance.collection('chats/hZRcDJ1IrtcwpOwi5iHq/messages');

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              drawer: DrawerMenu(),
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                // backgroundColor: Colors.orange,
                title: Text('Chat Room'),
              ),
              body: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Messages(),
                    ),
                    NewMessage(),
                  ],
                ),
              ),
            );
          } else
            return AuthScreen();
        });
  }
}
