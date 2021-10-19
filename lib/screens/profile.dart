import 'dart:io';
import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/personalChatScreen.dart';
import 'package:chatapp/utils/downladfile.dart';
import 'package:chatapp/widgets/drawer.dart';
import 'package:chatapp/widgets/profileWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  final userId;
  const ProfilePage({Key? key, @required this.userId}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? file;
  bool isLoading = false;

  // List userNotes = [];
  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.userId)
  //       .get()
  //       .then((docs) {
  //     if (docs.exists) {
  //       userNotes = docs.get('Notes');
  //     }
  //   });
  // }

  Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Uploading document')));
    final path = result.files.single.path!;

    final note = File(path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('usernotes')
        .child(widget.userId)
        .child(note.uri.pathSegments.last);
    await ref.putFile(note);
    final url = await ref.getDownloadURL();
    var userDoc =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);
    await userDoc.update({
      'Notes': FieldValue.arrayUnion([
        {
          'filename': note.uri.pathSegments.last,
          'url': url,
        }
      ])
    });
    setState(() {});
    print('completed adding notes');
    isLoading = false;
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Succefully uploaded')));
  }

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot> _fetch() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
    }

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              drawer: DrawerMenu(),
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
              body: FutureBuilder<DocumentSnapshot>(
                  future: _fetch(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? CircularProgressIndicator()
                        : ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              ProfileWidget(
                                imagePath: snapshot.data!.get('imageUrl'),
                                onClicked: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/editScreen');
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  Text(
                                    snapshot.data!.get('username'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  // const SizedBox(height: 4),
                                  Text(
                                    snapshot.data!.get('email'),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: snapshot.data?.id !=
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            final user = snapshot.data!.docs
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    widget.userId);
                                            return RaisedButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PersonalChatScreen(
                                                      user: user);
                                                }));
                                              },
                                              child: Text('Send Message'),
                                              color: Colors.cyan.shade200,
                                            );
                                          })
                                      : Text('Your Profile')),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const SizedBox(width: 15),
                                  Text(
                                    'College name -',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(snapshot.data!.get('college')),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'About:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Hello My name is .......................................',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 20),
                                    Text('Uploaded Notes',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        ShowNotes(widget: widget),
                                        const SizedBox(width: 5),
                                        isLoading
                                            ? CircularProgressIndicator()
                                            : FlatButton(
                                                onPressed: () =>
                                                    selectFile(context),
                                                child: Text('Add notes'),
                                                color: Colors.cyan,
                                              )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                  }),
            );
          } else
            return AuthScreen();
        });
  }
}

class ShowNotes extends StatelessWidget {
  const ShowNotes({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ProfilePage widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final userNotes = snapshot.data?.get('Notes');
            return (userNotes.isEmpty)
                ? Text('add your notes')
                : Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userNotes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              print('startingggg....');
                              downloadFile(
                                  userNotes[index]['url'],
                                  userNotes[index]['filename'],
                                  (await getExternalStorageDirectory())!.path,
                                  context);
                            },
                            trailing: IconButton(
                                onPressed: () async {
                                  print('startingggg....');
                                  downloadFile(
                                      userNotes[index]['url'],
                                      userNotes[index]['filename'],
                                      (await getExternalStorageDirectory())!
                                          .path,
                                      context);
                                },
                                icon: Icon(Icons.download)),
                            leading: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.52,
                                child:
                                    NoteW(text: userNotes[index]['filename'])),
                          );
                        }),
                  );
          }
        });
  }
}

class NoteW extends StatelessWidget {
  final String text;
  const NoteW({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: 220,
      width: 220,
      child: Text(text),
    );
  }
}
