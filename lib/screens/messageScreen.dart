import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/personalChatScreen.dart';
import 'package:chatapp/utils/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final userDocs = snapshot.data!.docs
                      .where((element) => element.id != FirebaseAuth.instance.currentUser!.uid
                      )
                      .toList();
                  return ListView.builder(
                    itemCount: userDocs.length,
                    itemBuilder: (ctx, index) {
                      final QueryDocumentSnapshot<Object?> user = userDocs[index];
    
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        elevation: 1,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PersonalChatScreen(
                                user: user,
                              );
                            }));
                          },
                          leading: CircleAvatar(
                            radius: 30,
                            foregroundImage: NetworkImage(user.get('imageUrl')),
                          ),
                          title: Text(
                            user.get('username'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            'Last Message',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
        );
  }
}
