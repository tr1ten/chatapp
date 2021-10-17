import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/chatScreen.dart';
import 'package:chatapp/screens/messageScreen.dart';
// import 'package:chatapp/screens/personalChatScreen.dart';
import 'package:chatapp/screens/profile.dart';
import 'package:chatapp/utils/authService.dart';
import 'package:chatapp/widgets/tabbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'ChatApp',
                theme: ThemeData(
                  primarySwatch: Colors.cyan,
                  // backgroundColor:
                ),
                home: AuthService().handleAuthState(),
                routes: {
                  '/chatScreen': (context) => ChatScreen(),
                  '/messageScreen': (context) => MessageScreen(),
                  '/profileScreen': (context) => ProfilePage(),
                  '/authScreen': (context) => AuthScreen(),
                  '/tabsScreen' : (context) => TabsScreen()
                }
                );
      
  }
}
