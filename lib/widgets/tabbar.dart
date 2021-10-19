import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/messageScreen.dart';
import 'package:chatapp/widgets/drawer.dart';
import 'package:chatapp/widgets/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                drawer: DrawerMenu(),
                appBar: AppBar(
                  title: Text('ChatApp'),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.message),
                        text: 'Messages',
                      ),
                      Tab(
                        icon: Icon(Icons.search),
                        text: 'Search',
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    MessageScreen(),
                    Searchoption(),
                  ],
                ),
              ),
            );
          } else
            return AuthScreen();
        });
  }
}
