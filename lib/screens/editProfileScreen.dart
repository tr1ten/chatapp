import 'dart:io';

// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:chatapp/widgets/profileWidget.dart';
import 'package:chatapp/widgets/textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  @override
  Widget build(BuildContext context) =>  Scaffold(
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
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fstatusqueen.com%2Fdp&psig=AOvVaw3zcabI4fOBw_yjNSno1ZHQ&ust=1634563314685000&source=images&cd=vfe&ved=0CAkQjRxqFwoTCNi4rYTF0fMCFQAAAAAdAAAAABAJ',
                  isEdit: true,
                  onClicked: () async {

                  },
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Full Name',
                  text: '',
                  onChanged: (name) {},
                ),
                const SizedBox(height: 24),
                // TextFieldWidget(
                //   label: 'Email',
                //   text: 'user.email',
                //   onChanged: (email) {},
                // ),
                TextFieldWidget(
                  label: 'About',
                  text: 'user.about',
                  maxLines: 5,
                  onChanged: (about) {},
                ),
                const SizedBox(height: 24),
                FlatButton(onPressed: (){}, child: Text('Save'),
                color: Colors.cyan,
                )
              ],
            ),
      );
}