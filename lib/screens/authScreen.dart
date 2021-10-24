import 'dart:io';
import 'dart:math';
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
  void submitForm(
    String email,
    String username,
    String pass,
    String college,
    String branch,
    bool islogin,
    BuildContext context,
    File? image,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (islogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'about': 'I am $username ...',
          'email': email,
          'imageUrl': url,
          'college': college,
          'branch': branch,
          'Notes': [],
        });
      }
    } on FirebaseAuthException catch (error) {
      // print('object');
      var message = 'Error Occurred! Please check your credentials';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _isloading = false;
      });
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(error.toString()),
      //   backgroundColor: Colors.red,
      //   )
      // );
      print(error);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("asserts/images/login.jpg"),
                  fit: BoxFit.cover),
              // gradient: LinearGradient(
              //   colors: [
              //     Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
              //     Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   stops: [0, 1],
              // ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.cyan.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'ChatApp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthForm(submitForm, _isloading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
