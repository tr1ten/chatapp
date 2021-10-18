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
    // const Image img = NetworkImage('');
    final image = NetworkImage(userData?['imageUrl'] ??
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTguqThAF5hdU3HGdSEuLRdnRJx6HmoROJnRllMwZ0DPXm9U4U4Jh4n5Z2NL0zfAtUAaPs&usqp=CAU");
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.grey.shade50, Colors.cyanAccent])),
              child: FittedBox(
                fit: BoxFit.contain,
                child: CircleAvatar(
                  foregroundImage: image,
                ),
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
