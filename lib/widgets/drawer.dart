import 'package:chatapp/utils/authService.dart';
import 'package:flutter/material.dart';

class Drawermenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.grey.shade50, Colors.cyanAccent])),
            child: CircleAvatar()),
        ListTile(
          title: Text("Profile"),
          // contentPadding: EdgeInsets.all(10),
          onTap: () =>
              {Navigator.of(context).pushNamed('/profileScreen')},
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
            Navigator.of(context).pushReplacementNamed('/tabsScreen')
          ,
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