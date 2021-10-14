import 'package:chatapp/widgets/messageBubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
          future: Future.value(FirebaseAuth.instance.currentUser),
          builder: (ctx , fsnapshot) {
          if(fsnapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt' , descending: true).snapshots(),
      // initialData: initialData,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        final chatDocs = snapshot.data!.docs;
        return  ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (BuildContext context, int index) {
            return MessageBubble(chatDocs[index]['text'],
            chatDocs[index]['userId'] == fsnapshot.data!.uid,
            chatDocs[index]['username'],
            chatDocs[index]['image'],
            key: ValueKey(chatDocs[index].id),
            );
           },
          );
          }
        );
      },
    );
  }
}