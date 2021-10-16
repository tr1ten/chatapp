import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/chatScreen.dart';
import 'package:chatapp/screens/messageScreen.dart';
import 'package:chatapp/screens/personalChatScreen.dart';
import 'package:chatapp/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        // initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
        return MaterialApp(
        home: snapshot.hasData ? MessageScreen() : AuthScreen(),
      debugShowCheckedModeBanner: false,
      title: 'ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        // backgroundColor: 
      ),
      routes:{ '/chatScreen': (context) => ChatScreen(),
      '/messageScreen': (context) => MessageScreen(),
      '/personalChatScreen': (context) => PersonalChatScreen(),
      '/profileScreen': (context) => ProfilePage(),
      }
      );


      }
    );
  }
}