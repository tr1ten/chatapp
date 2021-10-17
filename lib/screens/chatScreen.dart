import 'package:chatapp/widgets/drawer.dart';
import 'package:chatapp/widgets/messages.dart';
import 'package:chatapp/widgets/newMessage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  // final CollectionReference data = FirebaseFirestore.instance.collection('chats/hZRcDJ1IrtcwpOwi5iHq/messages');

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  // void initState() {
  //   final fbm = FirebaseMessaging.instance;
  //   fbm.requestPermission();
  //   FirebaseMessaging.onMessage.listen((event) {
  //     print(event);
  //     });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawermenu(),
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        // backgroundColor: Colors.orange,
        title: Text('ChatApp'),
        // actions: [
        //   DropdownButton(
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: Colors.black,
        //     ),
        //     items: [
        //       DropdownMenuItem(
        //         child: Container(
        //           child: Column(
        //             children: [
        //               Row(
        //                 children: [
        //                   Icon(Icons.exit_to_app),
        //                   SizedBox(width: 5),
        //                   Text('Logout'),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //         value: 'logout',
        //       ),
        //     ],
        //     onChanged: (itemIdentifier) {
        //       if (itemIdentifier == 'logout') {
        //         FirebaseAuth.instance.signOut();
        //         print('successfully logout from chatscreen!');
        //       }
        //     },
        //   ),
        // ],
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
  }
}
