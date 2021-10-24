import 'dart:io';
import 'package:chatapp/screens/authScreen.dart';
import 'package:chatapp/screens/personalChatScreen.dart';
import 'package:chatapp/theme.dart';
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
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final userId;
  const ProfilePage({Key? key, @required this.userId}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? file;
  bool isLoading = false;
  var _expanded = false;

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Uploading file...'),
    ));
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
    isLoading = false;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Succesfully uploaded'),
    ));
  }

  bool currentuser(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    return snapshot.data?.id != FirebaseAuth.instance.currentUser!.uid;
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: 200,
      width: 300,
      child: child,
    );
  }

  void gotoChat(context, DocumentSnapshot user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PersonalChatScreen(user: user);
    }));
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
                backgroundColor: Colors.cyan,
                elevation: 0,
                actions: [
                  Consumer<MyThemeNotify>(
                    builder: (context, value, child) {
                      return IconButton(
                        icon: Icon(value.isDark
                            ? CupertinoIcons.moon_stars_fill
                            : CupertinoIcons.moon_stars),
                        onPressed: () {
                          value.toggleDark();
                        },
                      );
                    },
                  ),
                ],
              ),
              body: FutureBuilder<DocumentSnapshot>(
                  future: _fetch(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
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
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: currentuser(snapshot)
                                    ? ElevatedButton(
                                        onPressed: () =>
                                            gotoChat(context, snapshot.data!),
                                        child: Text('Send Message'),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.cyan.shade200))
                                    : SizedBox(),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "About:",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      snapshot.data!.get('about'),
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey.shade700,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Uploaded Notes:",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Card(
                                      child: ListTile(
                                        title: Text('Notes'),
                                        trailing: IconButton(
                                          icon: Icon(_expanded
                                              ? Icons.expand_less
                                              : Icons.expand_more),
                                          onPressed: () {
                                            setState(() {
                                              _expanded = !_expanded;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        height: _expanded ? 200 : 0,
                                        width: double.infinity,
                                        child: ShowNotes(widget: widget)),
                                    if (!currentuser(snapshot))
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.cyan),
                                        onPressed: () => selectFile(context),
                                        child: isLoading
                                            ? CircularProgressIndicator(
                                                color: Colors.black,
                                              )
                                            : Text('Add notes'),
                                      ),
                                  ],
                                ),
                              ),
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

  Widget buildContainer(BuildContext context, Widget child,
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey),
        // borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: child,
    );
  }

  bool currentuser(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    return snapshot.data!.id == FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildContainer(
                context, Center(child: CircularProgressIndicator()), snapshot);
          } else {
            final userNotes = snapshot.data!.get('Notes');
            if (userNotes.isEmpty && currentuser(snapshot)) {
              return buildContainer(context,
                  Center(child: Text('Add your notes here!!')), snapshot);
            }
            if (userNotes.isEmpty && !currentuser(snapshot)) {
              return buildContainer(context,
                  Center(child: Text('No Notes Uploaded Yet')), snapshot);
            } else
              return buildContainer(
                  context,
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: userNotes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () async {
                                  print('startingggg....');
                                  downloadFile(
                                      userNotes[index]['url'],
                                      userNotes[index]['filename'],
                                      (await getExternalStorageDirectory())!
                                          .path,
                                      context);
                                },
                                trailing: IconButton(
                                    onPressed: () async {
                                      downloadFile(
                                          userNotes[index]['url'],
                                          userNotes[index]['filename'],
                                          (await getExternalStorageDirectory())!
                                              .path,
                                          context);
                                    },
                                    icon: Icon(Icons.download)),
                                title: Text(userNotes[index]['filename']),
                                // leading: SizedBox(
                                //     width: MediaQuery.of(context).size.width * 0.45,
                                //     child:
                                //         NoteW(text: userNotes[index]['filename'])),
                              ),
                              // Divider(
                              //   thickness: 2,
                              // ),
                            ],
                          ),
                        );
                      }),
                  snapshot);
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
      // decoration: BoxDecoration(border: Border.all(width: 0.5)),
      height: 220,
      width: 220,
      child: Text(text),
    );
  }
}
