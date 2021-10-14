
import 'dart:io';

import 'package:chatapp/widgets/authForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}


class _AuthScreenState extends State<AuthScreen> {
  var _isloading = false;
 final _auth = FirebaseAuth.instance;
  void submitForm(String email,String username,String pass,bool islogin ,
  BuildContext context,
  File? image, 
   ) async {
    UserCredential authResult;
    try{
      setState(() {
        _isloading = true;
      });
    if(islogin){
      authResult  = await _auth.signInWithEmailAndPassword(email: email, password: pass);
    }
    else{
      authResult = await _auth.createUserWithEmailAndPassword(email: email, password: pass);

      final ref = FirebaseStorage.instance.ref().child('user_image').child(authResult.user!.uid + '.jpg');
      await ref.putFile(image!);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
        'username' : username,
        'email' : email,
        'imageUrl' : url,
      });
    }
  } on FirebaseAuthException catch(error){
    // print('object');
    var message = 'Error Occurred! Please check your credentials';
    if(error.message != null){
      message = error.message!;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),
      backgroundColor: Colors.red,
      )
    );
        setState(() {
      _isloading=false;
    });
    }
     catch (error){
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(error.toString()),
    //   backgroundColor: Colors.red,
    //   )
    // );
    print(error);
    setState(() {
      _isloading=false;
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      // appBar: AppBar(title: Text('ChatApp'),),
      body: AuthForm(submitForm , _isloading),
    );
  }
}