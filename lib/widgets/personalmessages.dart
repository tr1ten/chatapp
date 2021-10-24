import 'package:chatapp/widgets/messageBubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PMessages extends StatelessWidget {
  final DocumentSnapshot<Object?> toUser;

  const PMessages({Key? key, required this.toUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, fsnapshot) {
        if (fsnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<String> validUsers = [toUser.id, fsnapshot.data!.uid];
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('personalChats')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            // initialData: initialData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = snapshot.data!.docs.where((msgdoc) {
                return (validUsers.contains(msgdoc.get('fromId')) &&
                    validUsers.contains(msgdoc.get('toId')));
              }).toList();
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageBubble(
                    chatDocs[index]['text'],
                    chatDocs[index]['fromId'] == fsnapshot.data!.uid,
                    toUser['username'],
                    toUser['imageUrl'],
                    key: ValueKey(chatDocs[index].id),
                  );
                },
              );
            });
      },
    );
  }
}
