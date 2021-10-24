import 'package:chatapp/utils/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);
  Future<DocumentSnapshot> _fetch() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _fetch(), // async work
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[
                      Colors.grey.shade50,
                      Colors.cyanAccent
                    ])),
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: snapshot.connectionState ==
                                ConnectionState.waiting
                            ? CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    AssetImage("asserts/images/dp.png"),
                                foregroundImage: NetworkImage(
                                    snapshot.data!.get('imageUrl'))))),
                ListTile(
                  title: Text("Profile"),
                  // contentPadding: EdgeInsets.all(10),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/profileScreen');
                  },
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  title: Text("Chat room"),
                  onTap: () => {
                    Navigator.of(context).pushReplacementNamed('/chatScreen')
                  },
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
        });
  }
}
