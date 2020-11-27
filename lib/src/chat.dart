import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/Config/AppConfig.dart';
import 'Models/Comment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'Models/User.dart';
import 'Session/Singleton.dart';
class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Singleton _instance = Singleton.getState();


  Widget _buildAllUsers(){
    return ListView.builder(
      itemCount:  _instance.user.following.length,
      itemBuilder: (context, index) {

        return
          _buildSingleLiker(_instance.user.following[index]);              },
    );
  }
  Widget _buildAllUsersTop(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount:  _instance.user.following.length,
      itemBuilder: (context, index) {

        return
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: _instance.user.following[index].isOnline?Colors.green:Colors.grey,
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(AppConfig.PROFILE_IMAGE_URL + _instance.user.following[index].profileImageUrl),
                ),
              ));
      },
    );
  }

  Widget _buildSingleLiker(User user){
    return ListTile(
      leading: ClipOval(
          child:Container(
              width: 60,
              height: 60,
              child:CachedNetworkImage(
                imageUrl: AppConfig.PROFILE_IMAGE_URL + user.profileImageUrl,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    Image(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/user-placeholder.png')
                    ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              )
          )
      ),
      title:  Text(user.username,style: TextStyle(fontSize: 18,fontFamily: 'rabelo',fontWeight: FontWeight.bold)),
      subtitle: Text(
        user.user_firstName + " " + user.user_lastName,
        style: TextStyle(fontSize: 16,color: Colors.grey.withOpacity(0.6)),
      ),
      trailing: Icon(Icons.check_circle_outline),
    );
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body:
        Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                    height: 100,
                    child: _buildAllUsersTop()
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: null
                  ,),
                Divider(),
                Expanded(
                  child : _buildAllUsers(),
                )
              ],
            )
        )
    );
  }
}
