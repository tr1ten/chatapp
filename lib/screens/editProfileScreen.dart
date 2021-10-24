import 'dart:io';
import 'package:chatapp/widgets/profileWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formkey = GlobalKey<FormState>();
  final userDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  String _userName = '';
  String _userAbout = '';
  File? _userImage;
  void updateData() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // if (_userImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text('Please pick an image'), backgroundColor: Colors.red));
    //   return;
    // }
    _formkey.currentState!.save();
    if (isValid) {
      userDoc.update({
        "about": _userAbout,
        "username": _userName,
      }).then((value) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/profileScreen'),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.moon_stars),
              onPressed: () {},
            ),
          ],
        ),
        body: Form(
          key: _formkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath:
                    'https://www.google.com/url?sa=i&url=https%3A%2F%2Fstatusqueen.com%2Fdp&psig=AOvVaw3zcabI4fOBw_yjNSno1ZHQ&ust=1634563314685000&source=images&cd=vfe&ved=0CAkQjRxqFwoTCNi4rYTF0fMCFQAAAAAdAAAAABAJ',
                isEdit: true,
                onClicked: () async {},
              ),
              const SizedBox(height: 24),
              TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name cant be empty!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Full name'),
                  onSaved: (value) {
                    _userName = value!;
                  }),
              const SizedBox(height: 24),
              // TextFormField(
              //   label: 'Email',
              //   text: 'user.email',
              //   onChanged: (email) {},
              // ),
              TextFormField(
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'About cant be empty!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'About me',
                      hintText: 'I am a college student..'),
                  onSaved: (value) {
                    _userAbout = value!;
                  }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: updateData,
                child: Text('Save'),
              )
            ],
          ),
        ),
      );
}
