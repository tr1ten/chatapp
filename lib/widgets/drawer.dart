import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Drawermenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[
            Colors.deepOrange,
            Colors.orangeAccent
          ])
          ),
          child: CircleAvatar()
          ),
        ListTile(title: Text("Profile"),
        // contentPadding: EdgeInsets.all(10),
        onTap: ()=>{},
        ),
        Divider(thickness: 2,),
        ListTile(title: Text("Chat room"),
        onTap: ()=>{},
        // contentPadding: EdgeInsets.all(10),
        ),
        Divider(thickness: 2,),
        ListTile(title: Text("Settings"),
        onTap: ()=>{},
        // contentPadding: EdgeInsets.all(10),
        ),
        Divider(thickness: 2,),
        ListTile(title: Text("Log out"),
        onTap: ()=>{
            FirebaseAuth.instance.signOut()
        },
        // contentPadding: EdgeInsets.all(10),
        ),
        // Divider(thickness: 2,),        
      ]),
    );
  }
}
