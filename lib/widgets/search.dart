import 'package:flutter/material.dart';

class Searchoption extends StatelessWidget {
  // final void Function(String) onTextChange;

  // SearchBar({ this.onTextChange });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(8),
      child: TextField(
        // onChanged: ,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(Icons.search),
          hintText: 'Search someone ...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.zero
        )
      )
    );
  }
}
