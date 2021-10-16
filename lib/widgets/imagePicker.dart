import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatefulWidget {
  final void Function(File image) imagepickfn;
  ImagePick(this.imagepickfn);

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File? _myImage;

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final image =
        await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    widget.imagepickfn(File(image!.path));
    // ignore: unnecessary_null_comparison
    if (image == null) {
      return;
    }
    setState(() {
      _myImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: _myImage != null ? FileImage(_myImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add a image'),
        ),
      ],
    );
  }
}
