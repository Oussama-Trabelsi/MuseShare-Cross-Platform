import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_signup/src/Config/AppConfig.dart';
import 'package:flutter_login_signup/src/Service/post_service.dart';
import 'Models/Post.dart';
import 'Models/User.dart';
import 'data.dart';
import 'singlePost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Models/Comment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'player.dart';
import 'miniPlayer.dart';
import 'Models/items.dart';
import 'Session/Singleton.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomePageState extends State<HomePage> {
  var playing =false;
  var cards = Data.getData;
  PostWebService service;
  List<Post> posts;

  Singleton _instance;

  @override
  void initState() {
    super.initState();
    _instance = Singleton.getState();
    service = new PostWebService();
    // do something with this data: service.fetchPostsForUser(4);
    // like a post , return bool : service.likePost(13, 4);
    // dislike a post , return bool : service.dislikePost(13, 4);
    // do something with this data : service.fetchCommentsForPost(15);
    // like a comment , return bool : service.likeComment(13, 4);
    // dislike a comment , return bool : service.dislikeComment(13, 4);
  }
  Widget _buildAllPosts(){
    return FutureBuilder<List<Post>>(
        future: service.fetchPosts(_instance.logged_in_user.user_id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                width: 400,
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          }
          else{
            return Container(width : 400,child:ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(snapshot.data[index]);
              },
            )
            );
          }
        });
  }









  Widget _buildAllLikes(List<User> likes){
    return ListView.builder(
        itemCount:  likes.length,
        itemBuilder : (context, index) {
          return
            Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      child: _buildSingleLiker(likes[index])
                  )]
            );
        });
  }
  Widget _buildSingleLiker(User user){
    return ListTile(
      leading: ClipOval(
          child:Container(
              width: 50,
              height: 50,
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
      title:  Text(user.username,style: TextStyle(fontSize: 16,fontFamily: 'rabelo',fontWeight: FontWeight.bold)),
      subtitle: Text(
        user.user_firstName + " " + user.user_lastName,
        style: TextStyle(fontSize: 14,color: Colors.grey.withOpacity(0.6)),
      ),
      trailing: Container(
          width: 75,
          child : user.user_id!=_instance.user.user_id?!findFollowOrFollowed(user,_instance.user.following)?RaisedButton(
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
          ):null
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

  Widget _buildLikesPopUp(Post post){
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(

                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Likes',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold))
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child:  IconButton(
                                  icon: Icon(Icons.close,color: Colors.purpleAccent,size: 30,),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }
                              )
                          )
                        ],
                      ),
                      Divider(thickness: 1.5),
                      Expanded(
                        child : _buildAllLikes(post.likes),
                      )
                    ],
                  ),
                );
              });
        },
        child: Text(
          post.likesCount.toString()+ ' Likes',
          style: TextStyle(fontSize: 16,color: Colors.blue.withOpacity(0.6)),
        ));
  }

  Widget _buildCard(Post card) =>
      GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SinglePostPage(info: card),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: ClipOval(
                      child:Container(
                          width: 60,
                          height: 60,
                          child:CachedNetworkImage(
                            imageUrl: AppConfig.PROFILE_IMAGE_URL + card.user.profileImageUrl,
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
                  title:  Text(card.user.username,style: TextStyle(fontSize: 18,fontFamily: 'rabelo',fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    card.date.toString(),
                    style: TextStyle(fontSize: 16,color: Colors.grey.withOpacity(0.6)),
                  ),
                  trailing: Icon(Icons.more_vert),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      card.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.8)),
                    ),
                  ),),
                ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: AppConfig.TRACK_URL + card.iconUrl,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        Image(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/soundcloud.png')
                        ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                  )
                  ,
                  title:  Text(card.trackName,style: TextStyle(fontSize: 16,fontFamily: 'rabelo',fontWeight: FontWeight.bold)),
                  subtitle: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildLikesPopUp(card),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                          Text(
                            card.commentsCount.toString() + ' Comments',
                            style: TextStyle(fontSize: 16,color: Colors.blue.withOpacity(0.6)),
                          )

                        ],
                      )
                  ),
                  trailing: InkWell(
                      child:Icon(Icons.cloud_download,size: 40,),
                      onTap: () {

                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioApp(new Song(category: "none", image: AppConfig.TRACK_URL + card.iconUrl, name: card.description, artist: card.trackName, url: AppConfig.TRACK_URL + card.trackUrl)),
                          ),
                        );
                      }

                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            children: [
                              WidgetSpan(
                                  child: Container(
                                    padding: EdgeInsets.only(right:5.0),
                                    child: Icon(Icons.thumb_up_alt_outlined),
                                  )
                              ),
                              TextSpan(
                                text: 'Like',
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 50,vertical: 20)),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            children: [
                              WidgetSpan(
                                  child: Container(
                                    padding: EdgeInsets.only(right:5.0),
                                    child: Icon(Icons.comment),
                                  )
                              ),
                              TextSpan(
                                text: 'Comment',
                              ),
                            ],
                          ),
                        )

                      ],
                    )
                )
              ],
            ),
          ));

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:  Column(
          children:[
            !playing ?Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: Image(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/soundcloud.png',)
                ),
                title:  Text('Welcome to a whole new world of sound discovery. Select a track to start listening !'
                    ,style: TextStyle(fontSize: 16,)),

              ),
            ):
            Container(
              padding: EdgeInsets.only(top: 20),
              height: 124,
              child: Card(child:MiniAudioPlayer(new Song(category: "none", image: "https://i1.sndcdn.com/artworks-000245530126-40dfig-t500x500.jpg", name: "Cardi B is the bomb", artist: 'test', url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")))
              ,
            )
            ,
            Expanded(
                child:_buildAllPosts()
            ),
          ]
      ),
    );
  }
}