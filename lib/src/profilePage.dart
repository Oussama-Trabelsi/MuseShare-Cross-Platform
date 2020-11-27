import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_signup/src/Config/AppConfig.dart';
import 'package:flutter_login_signup/src/Models/Post.dart';
import 'package:flutter_login_signup/src/singlePost.dart';
import 'Models/ImagePost.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_login_signup/src/Service/post_service.dart';
import 'Models/User.dart';
import 'Session/Singleton.dart';
import 'followers.dart';
class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String view = "grid"; // default view
  Singleton _instance;
  User user;
  PostWebService service;

  @override
  void initState() {
    super.initState();
    service = new PostWebService();
    _instance = Singleton.getState();
    user = _instance.logged_in_user;
  }


  Container buildUserPosts() {
    return Container(
        child: FutureBuilder<List<Post>>(
            future: service.fetchPostsForUser(user.user_id),
            builder: (context, snapshot) {
              if (snapshot.hasData){
                if (view == "grid") {
                  if (snapshot.data.length==0)
                    return  Image(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/no_comments.png',)
                    );

                  // build the grid
                  return GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
//                    padding: const EdgeInsets.all(0.5),
                      mainAxisSpacing: 1.5,
                      crossAxisSpacing: 1.5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data.map((Post post) {
                        return GridTile(child: ImageTile(post));
                      }).toList());
                }
                else if (view == "feed") {
                  if (snapshot.data.length==0)
                    return  Image(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/no_comments.png',)
                    );

                  return Column(
                      children: snapshot.data.map((Post post) {
                        return Card(
                            child : Padding(
                                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                child: GestureDetector(
                                  onDoubleTap: () => {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SinglePostPage(info: post),
                                    ),
                                  )
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl: AppConfig.TRACK_URL + post.iconUrl,
                                        fit: BoxFit.fitWidth,
                                        placeholder: (context, url) =>
                                            Image(
                                                fit: BoxFit.fill,
                                                image: AssetImage('assets/soundcloud.png',)
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      post.id == 0
                                          ? Positioned(
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: Opacity(
                                              opacity: 0.85,
                                              child: FlareActor("assets/flare/Like.flr",
                                                animation: "Like",
                                              )),
                                        ),
                                      )
                                          : Container()
                                    ],
                                  ),
                                )
                            )

                        );
                      }).toList());
                }
              }
              else {
                return Container(
                    alignment: FractionalOffset.center,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CircularProgressIndicator());
              }
            }
        )
    );
  }
  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }
  Row buildImageViewButtonBar() {
    Color isActiveButtonColor(String viewName) {
      if (view == viewName) {
        return Colors.blueAccent;
      } else {
        return Colors.black26;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on, color: isActiveButtonColor("grid")),
          onPressed: () {
            changeView("grid");
          },
        ),
        IconButton(
          icon: Icon(Icons.list, color: isActiveButtonColor("feed")),
          onPressed: () {
            changeView("feed");
          },
        ),
      ],
    );
  }


  Column buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400),
            ))
      ],
    );
  }
  Container buildFollowButton(
      {String text,
        Color backgroundcolor,
        Color textColor,
        Color borderColor,
        Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5.0)),
            alignment: Alignment.center,
            child: Text(text,
                style: TextStyle(
                    color: textColor, fontWeight: FontWeight.bold)),
            width: 250.0,
            height: 27.0,
          )),
    );
  }
  Container buildProfileFollowButton() {
    // viewing your own profile - should show edit button
    return buildFollowButton(
      text: "Edit Profile",
      backgroundcolor: Colors.white,
      textColor: Colors.black,
      borderColor: Colors.grey,
      // function: editProfile,
    );
  }



  Widget _buildCard() =>
      Expanded(
          child:  ListView(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(AppConfig.PROFILE_IMAGE_URL + user.profileImageUrl),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    buildStatColumn("posts", user.postsCount != null ? user.postsCount : 0),
                                    GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FollowersAndFollowing(user : user),
                                            ),
                                          );
                                        },
                                        child:buildStatColumn("followers", user.followersCount != null ? user.followersCount : 0)),
                                    GestureDetector(
                                        onTap:(){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FollowersAndFollowing(user : user),
                                            ),
                                          );
                                        },
                                        child:buildStatColumn("following", user.followingCount != null ? user.followingCount : 0))
                                    ,
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Flexible(
                                        child: buildProfileFollowButton(),
                                      ),
                                    ]),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            user.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(user.user_bio),
                      ),
                      Divider(),
                      buildImageViewButtonBar(),
                      Divider(height: 0.0),
                    ],
                  ),
                ),),
              buildUserPosts()
            ],
          )
      );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:  Column(
          children:[
            _buildCard(),
          ]
      ),
    );
  }
}
class ImageTile extends StatelessWidget {
  final Post post;

  ImageTile(this.post);

  clickedImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SinglePostPage(info: post),
      ),
    );
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => clickedImage(context),
        child: Image.network(AppConfig.TRACK_URL + post.iconUrl, fit: BoxFit.cover));
  }
}

