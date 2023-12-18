import 'package:flutter/material.dart';


class SearchBarBlock extends StatelessWidget {
final TextEditingController controller;
final VoidCallback function;

SearchBarBlock({required this.controller,required this.function});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      backgroundColor: MaterialStateProperty.all(Colors.white),
      controller:controller,
      hintText: 'search',
      hintStyle: MaterialStateProperty.all(
          TextStyle(color: Colors.black87.withOpacity(0.7),
              fontSize: 18)),
      leading: IconButton(icon: Icon(
        Icons.search, color: Colors.black87.withOpacity(0.7),),

        onPressed: function),
    );
  }
}
