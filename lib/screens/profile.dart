import 'dart:io';
import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/widgets/drawer.dart';
import 'package:chatapp/widgets/profileWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userDetail = FirebaseAuth.instance.currentUser;
  File? file;
Future selectFile () async {
final result = await FilePicker.platform.pickFiles(allowMultiple: false);
if(result == null){
  return;
}
final path = result.files.single.path!;
setState(() {
file = File(path);
});
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              drawer: Drawermenu(),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(CupertinoIcons.moon_stars),
                    onPressed: () {},
                  ),
                ],
              ),
              body:
                 ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ProfileWidget(
                imagePath: '',
                onClicked: () {
                  Navigator.of(context).pushReplacementNamed('/editScreen');
                },
              ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          'User Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        // const SizedBox(height: 4),
                        Text(
                          'user.email',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: RaisedButton(onPressed: () {}, child: Text('Send Message'),
                      color: Colors.cyan.shade200,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Text(
                            'College: ',
                            style:
                                TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                    Text('College name'),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Hello My name is .......................................',
                            style: TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 20),
                          Text('Uploaded Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(
                                  width: 0.5
                                )),
                                height: 220,
                                width: 220,
                                child: Text('hhhh'),
                              ),
                              const SizedBox(width: 5),
                              FlatButton(onPressed: selectFile,
                              child: Text('Add notes'),
                              color: Colors.cyan,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
            );
          } else
            return AuthScreen();
        });
  }
}
