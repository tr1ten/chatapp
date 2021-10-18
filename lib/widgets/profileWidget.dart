import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage('https://images.unsplash.com/photo-1614680376408-81e91ffe3db7?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8d2hhdHNhcHAlMjBkcHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80');

    return ClipOval(
      child: Material(
        color: Colors.cyan,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 2,
          child: IconButton(
            onPressed: isEdit? (){} : onClicked , 
            icon: Icon(isEdit ? Icons.add_a_photo : Icons.edit,size: 20,),
            color: Colors.white,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          height: 45,
          width: 45,
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}