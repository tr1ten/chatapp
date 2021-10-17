import 'package:chatapp/utils/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Drawermenu extends StatefulWidget {
  @override
  State<Drawermenu> createState() => _DrawermenuState();
}

class _DrawermenuState extends State<Drawermenu> {
  var userData;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        userData = value.data();
        print('calling setstate');
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.grey.shade50, Colors.cyanAccent])),
              child: CircleAvatar(
                foregroundImage: NetworkImage(userData?['imageUrl'] ??
                    "https://www.pngmagic.com/product_images/solid-light-blue-background.jpg"),
              )),
          ListTile(
            title: Text("Profile"),
            // contentPadding: EdgeInsets.all(10),
            onTap: () => {Navigator.of(context).pushNamed('/profileScreen')},
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Chat room"),
            onTap: () =>
                {Navigator.of(context).pushReplacementNamed('/chatScreen')},
            // contentPadding: EdgeInsets.all(10),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Messages"),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed('/tabsScreen'),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Settings"),
            onTap: () => {},
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Log out"),
            onTap: () => AuthService().logOut(context),
            // contentPadding: EdgeInsets.all(10),
          ),
          // Divider(thickness: 2,),
        ],
      ),
    );
  }
}
