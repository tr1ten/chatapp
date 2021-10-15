import 'package:chatapp/screens/personalChatScreen.dart';
import 'package:chatapp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MessageScreen extends StatelessWidget {
  const MessageScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawermenu(),
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('ChatApp'),
      actions: [
        DropdownButton(
        icon: Icon(Icons.more_vert, color: Colors.black,),  
        items: [
          DropdownMenuItem(child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 5),
                    Text('Logout'),
                  ],
                ),
              ],
            ),
          ),
          value: 'logout',
          ),
        ],
        onChanged: (itemIdentifier){
          if(itemIdentifier == 'logout'){
            FirebaseAuth.instance.signOut();
          }
        },
       ),
      ],
      ),
      body: ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                elevation: 1,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/personalChatScreen');
                  },
                  leading: CircleAvatar(

                    radius: 30,
                  ),
                  title: Text(
                  'UserName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Last Message',
                    style: TextStyle(color: Colors.grey,),
                  ),
                ),
              );
            },
            itemCount: 2,
          ),
    );
  }
}