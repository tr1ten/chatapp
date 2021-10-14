import 'dart:io';
import 'package:chatapp/widgets/imagePicker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function submitform;
  final bool _isloading;
  AuthForm(this.submitform, this._isloading); 

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _islogin = true;
  final _formkey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPass = '';
  File? _userImage;

  void _pickedImage(File image){
    _userImage = image;
  }

  void _trySubmit (){
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(_userImage == null && !_islogin){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please pick an image'),
      backgroundColor: Colors.red
      )
      );
      return;
    }
    if(isValid){
      print(_userImage);
      _formkey.currentState!.save();
      widget.submitform(
        _userEmail.trim(),
        _userName.trim(),
        _userPass.trim(),
        _islogin,
        context,
        _userImage,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(!_islogin)
              ImagePick(_pickedImage),
              TextFormField(
                key: ValueKey('email'),
                validator: (value){
                  if(value!.isEmpty || !value.contains('@')){
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email Address'
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value){
                  _userEmail = value!;
                },
                ),
                if(!_islogin)
                TextFormField(
                  key: ValueKey('username'),
                  validator: (value){
                  if(value!.isEmpty || value.length < 4 ){
                    return 'Enter a username with atleast 4 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'User Name'
                ),
                onSaved: (value){
                  _userName = value!;
                },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value){
                  if(value!.isEmpty || value.length < 7 ){
                    return 'Enter a password with atleast 7 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password'
                ),
                obscureText: true,
                onSaved: (value){
                  _userPass = value!;
                },
                ),
                SizedBox(height: 12,),
                if(widget._isloading)
                CircularProgressIndicator(),
                if(!widget._isloading)
                ElevatedButton(onPressed: _trySubmit, child: Text(_islogin? 'Login' : 'SignUp'),),
                if(!widget._isloading)
                TextButton(onPressed: () {
                  setState(() {
                    _islogin = !_islogin;
                  });
                }, child: Text(_islogin? 'Create a new account' : 'I already have an account'))
            ],
          )
          ),
          ),
        ),
        ),
    );
  }
}