import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Components/customProfileAppBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Config/AppConfig.dart';
import 'Models/Comment.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_login_signup/src/Config/AppConfig.dart';
import 'package:flutter_login_signup/src/Service/post_service.dart';
import 'Models/Post.dart';
import 'Session/Singleton.dart';

class SinglePostPage extends StatefulWidget {
  Post info;
  SinglePostPage({Key key,@required this.info}) : super(key: key);


  @override
  _SinglePostPageeState createState() => _SinglePostPageeState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SinglePostPageeState extends State<SinglePostPage> {
  bool didFetchComments = false;
  List<Comment> fetchedComments = [];
  PostWebService service= new PostWebService();
  Singleton _instance = Singleton.getState();
  bool comment= false;
  String actualComment= "insert comment here !";
  TextEditingController commentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("yo");
    commentController = new TextEditingController();
  }



  Widget buildSingleComment(Comment comment){

    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Text(
                  comment.user.username,
                  style: TextStyle(fontSize: 16,fontFamily: 'rabelo',color: Colors.blue,fontWeight: FontWeight.bold)
              )),
          subtitle: Bubble(
            color: Color.fromRGBO(212, 234, 244, 1.0),
            child: Padding(padding:EdgeInsets.symmetric(vertical: 10),child:Text(comment.content, style: TextStyle(fontSize: 11.0))),
          ),
          leading: ClipOval(
              child:Container(
                  width: 60,
                  height: 60,
                  child:CachedNetworkImage(
                    imageUrl: AppConfig.PROFILE_IMAGE_URL + comment.user.profileImageUrl,
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
          trailing: _instance.user.user_id==comment.user.user_id?IconButton(iconSize:20,onPressed: (){service.removeComment(comment.id);},icon: Icon(Icons.delete),):null,
        ),
        Divider(),
      ],
    );
  }


  Widget buildComments() {
    if (this.didFetchComments == false){
      return FutureBuilder<List<Comment>>(
          future: service.fetchCommentsForPost(widget.info.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());
            }
            else{
              this.didFetchComments = true;
              this.fetchedComments = snapshot.data;
              if (snapshot.data.length==0)
                return  Image(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/no_comments.png',)
                );
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildSingleComment(snapshot.data[index]);
                },
              );
            }
          });
    } else {
      // for optimistic updating
      return ListView.builder(
        shrinkWrap: true,
        itemCount: fetchedComments.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleComment(fetchedComments[index]);
        },
      );
    }
  }



  Widget _buildCard(Post card) =>

      Card(
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
              title:  Text(card.trackName,style: TextStyle(fontSize: 18,fontFamily: 'rabelo',fontWeight: FontWeight.bold)),
              subtitle: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        card.likesCount.toString() + ' Likes',
                        style: TextStyle(fontSize: 16,color: Colors.blue.withOpacity(0.6)),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Text(
                        card.commentsCount.toString() + ' Comments',
                        style: TextStyle(fontSize: 16,color: Colors.blue.withOpacity(0.6)),
                      )

                    ],
                  )
              ),
              trailing: Icon(Icons.cloud_download,size: 40,),
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
                    GestureDetector(
                      onTap: (){setState(() {
                        comment=!comment;
                      });},
                      child: Text.rich(
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
                    ),)


                  ],
                )
            ),
            comment?Padding(padding: EdgeInsets.symmetric(vertical: 5), child:ListTile(
              leading: ClipOval(
                  child:Container(
                      width: 60,
                      height: 60,
                      child:CachedNetworkImage(
                        imageUrl: AppConfig.PROFILE_IMAGE_URL + _instance.user.profileImageUrl,
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
              subtitle:  TextField(
                controller: commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'insert comment here !',
                ),
              ),
              trailing:  RaisedButton(
                child: Text('add',style: TextStyle(fontSize: 12),),
                textColor: Colors.white,
                color: Colors.grey,
                onPressed: () {
                  service.addComment(commentController.text, card.id, _instance.user.user_id);
                  // Respond to button press
                },
              ),
            )
            ):Container()
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomProfileAppBar(route:'singlePost'),
      body:  Column(
          children:[
            _buildCard(widget.info),
            Divider(),
            Expanded(
              child: buildComments(),
            ),
          ]
      ),
    );
  }
}