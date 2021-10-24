import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PNewMessage extends StatefulWidget {
  final DocumentSnapshot<Object?> userdoc;

  const PNewMessage({Key? key, required this.userdoc}) : super(key: key);
  @override
  _PNewMessageState createState() => _PNewMessageState();
}

class _PNewMessageState extends State<PNewMessage> {
  var _controller = new TextEditingController();
  String _enteredMessage = '';
  void _sendmessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('personalChats').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'fromId': user!.uid,
      'toId': this.widget.userdoc.id
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 2),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Send a message..'),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendmessage,
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
