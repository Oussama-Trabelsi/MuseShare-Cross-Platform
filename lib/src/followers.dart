import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'Config/AppConfig.dart';
import 'Models/User.dart';
import 'Session/Singleton.dart';


class FollowersAndFollowing extends StatefulWidget {
  User user;
  FollowersAndFollowing({Key key,@required this.user}) : super(key: key);


  @override
  _FollowersAndFollowingState createState() => _FollowersAndFollowingState();
}


class _FollowersAndFollowingState extends State<FollowersAndFollowing> {

  Singleton _instance = Singleton.getState();

  @override
  void initState() {

  }


  Widget _buildAllFollowersAndFollowing(List<User> followers){
    return ListView.builder(
        itemCount:  followers.length,
        itemBuilder : (context, index) {
          return
            Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      child: _buildSingleFollower(followers[index])
                  )]
            );
        });
  }
  Widget _buildSingleFollower(User user){
    return ListTile(
      leading: ClipOval(
          child:Container(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
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
      title:  Text(user.username,style: TextStyle(fontSize: 16,fontFamily: 'rabelo',fontWeight: FontWeight.bold)),
      subtitle: Text(
        user.user_firstName + " " + user.user_lastName,
        style: TextStyle(fontSize: 14,color: Colors.grey.withOpacity(0.6)),
      ),
      trailing: Container(
          width: 75,
          child : !findFollowOrFollowed(user,_instance.user.followers)?RaisedButton(
            child: Text('follow',style: TextStyle(fontSize: 10),),
            textColor: Colors.white,
            color: Color(0xFF6200EE),
            onPressed: () {
              // Respond to button press
            },
          ):
          RaisedButton(
            child: Text('followed',style: TextStyle(fontSize: 10),),
            textColor: Colors.white,
            color: Colors.grey,
            onPressed: () {
              // Respond to button press
            },
          )
      ),
    );
  }
  bool findFollowOrFollowed(User user,List<User> following){
    for(User u in following){
      if (u.user_id==user.user_id)
        return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
              title: Transform(
                // you can forcefully translate values left side using Transform
                transform:  Matrix4.translationValues(10, 0.0, 0.0),
                child: Text(widget.user.username,style: TextStyle(color: Colors.black,fontFamily: 'rabelo',fontWeight: FontWeight.bold, fontSize: 20)),),
              backgroundColor: Colors.white,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert,color: Colors.black,size: 26),
                    tooltip: 'Show Snackbar',
                    onPressed: () {
                    },
                  ),
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(child: Text("Followers",style: TextStyle(color: Colors.black,fontSize: 20),),),
                  Tab(child: Text("Following",style: TextStyle(color: Colors.black,fontSize: 20),)),
                ],
              )
          ),
          body: TabBarView(
            children: [
              Column(children: [
                Expanded(
                  child : _buildAllFollowersAndFollowing(widget.user.followers),
                )

              ],),
              Column(children: [
                Expanded(
                  child : _buildAllFollowersAndFollowing(widget.user.following),
                )

              ],),
            ],
          ),
        ),
      ),
    );
  }
}