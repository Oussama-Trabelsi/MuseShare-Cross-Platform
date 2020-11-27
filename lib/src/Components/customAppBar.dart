import 'package:flutter/material.dart';
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}


class _CustomAppBarState extends State<CustomAppBar>{
  @override
  Widget build(BuildContext context) {

    // Use the Todo to create the UI.
    return AppBar(
      leading: Icon(Icons.library_music_outlined,color: Colors.black54,size: 28),
      backgroundColor: Colors.white,
      title: Image(
        image: AssetImage('assets/social_hub.png',
        ),
      )
      ,
      actions: [

      ],
    );
  }
}