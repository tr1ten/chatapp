import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Determine if the user is authenticated and redirect accordingly
  handleAuthState() {
    return 
     StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          print("Your data: $snapshot");
          print('1234688987');
          return ChatScreen();
        } 
        else
          print('logged out');
          return AuthScreen();
          
      },
    );
  }

  // signout()
  signOut() {
    _auth.signOut();
  }

  // Logout
  Future logOut(BuildContext context) async {
    try {
      await _auth.signOut().then((value) {
        AuthService().handleAuthState();
      });
       await _auth.signOut().then((value) =>
        AuthService().handleAuthState()
      );
    } catch (e) {
      print(e);
    }
  }
}

// Reset Password
Future<void> resetPassword(String email) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.sendPasswordResetEmail(email: email);
}
