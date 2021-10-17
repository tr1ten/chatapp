import 'package:chatapp/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //   Future<void> _getUserDetail() async {
  // final user = FirebaseAuth.instance.currentUser;
  // final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  //   }

  final userDetail = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawermenu(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.moon_stars),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                ),
                Positioned(
                  child: ClipOval(
                    child: Container(
                      color: Colors.blue,
                      // padding: EdgeInsets.all(1),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: () {},
                        iconSize: 20,
                      ),
                    ),
                  ),
                  bottom: 0,
                  right: 4,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Text(
                'User Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              // const SizedBox(height: 4),
              Text(
                'user.email',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListTile(
            leading: Text(
              'College:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            title: Text('College name'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Hello My name is .......',
                  style: TextStyle(
                      fontSize: 16, height: 1.2, color: Colors.black87),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
