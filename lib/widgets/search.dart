import 'package:chatapp/screens/personalChatScreen.dart';
import 'package:chatapp/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Searchoption extends StatefulWidget {
  // final void Function(String) onTextChange;

  // SearchBar({ this.onTextChange });

  @override
  State<Searchoption> createState() => _SearchoptionState();
}

class _SearchoptionState extends State<Searchoption> {
  List userDocs = [];
  List allData = [];
  late QuerySnapshot querySnapshot;
  final fcontroller = TextEditingController();
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');
  void initState() {
    super.initState();
    _collectionRef.get().then((value) {
      querySnapshot = value;
      allData = querySnapshot.docs
          .where(
              (element) => element.id != FirebaseAuth.instance.currentUser!.uid)
          .toList();
    });
    // Get data from docs and convert map to List
  }

  Future<void> updateData(keyword) async {
    // Get docs from collection reference

    final matchData =
        allData.where((element) => element.get('username').contains(keyword));

    userDocs = matchData.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.all(8),
          child: TextField(
              controller: fcontroller,
              onChanged: (text) => {
                    setState(() {
                      print("updating text $text");

                      updateData(text);
                    })
                  },
              decoration: InputDecoration(
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search someone ...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.zero)),
        ),
        Expanded(
          child: ListView(
              children: userDocs.map((user) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              elevation: 1,
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfilePage(userId: user.id);
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
          }).toList()),
        ),
      ],
    );
  }
}
