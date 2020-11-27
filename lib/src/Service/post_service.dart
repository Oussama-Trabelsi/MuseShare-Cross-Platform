import 'dart:convert';
import 'package:flutter_login_signup/src/Config/AppConfig.dart';
import 'package:flutter_login_signup/src/Models/Comment.dart';
import 'package:flutter_login_signup/src/Models/Post.dart';
import 'package:http/http.dart' as http;

class PostWebService {

  Future<List<Post>> fetchPosts(int user_id) async {
    // should fetch posts from followed users and current user's posts only
    String url = AppConfig.URL_ALL_POSTS;
    final response = await http.get(url + user_id.toString());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Post> posts = body
          .map(
            (dynamic item) => Post.fromJson(item),
      ).toList();
      return posts;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<List<Post>> fetchPostsForUser(int user_id) async {
    String url = AppConfig.URL_USER_POSTS;
    final response = await http.get(url + user_id.toString());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Post> posts = body
          .map(
            (dynamic item) => Post.fromJson(item),
      ).toList();
      return posts;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<bool> likePost(int post_id, int user_id) async {
    String url = AppConfig.URL_LIKE_POST;
    final response = await http.post(url + post_id.toString() + "/" + user_id.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> dislikePost(int post_id, int user_id) async {
    String url = AppConfig.URL_DISLIKE_POST;
    final response = await http.post(url + post_id.toString() + "/" + user_id.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  /* Comment api */
  Future<List<Comment>> fetchCommentsForPost(int post_id) async {
    String url = AppConfig.URL_POST_COMMENTS;
    final response = await http.get(url + post_id.toString());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Comment> comments = body
          .map(
            (dynamic item) => Comment.fromJson(item),
      ).toList();
      return comments;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<bool> likeComment(int comment_id, int user_id) async {
    String url = AppConfig.URL_LIKE_COMMENT;
    final response = await http.post(url + comment_id.toString() + "/" + user_id.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> dislikeComment(int comment_id, int user_id) async {
    String url = AppConfig.URL_DISLIKE_COMMENT;
    final response = await http.post(url + comment_id.toString() + "/" + user_id.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> addComment(String content, int post_id, int user_id) async {
    String url = AppConfig.URL_ADD_COMMENT;
    final response = await http.post(url, body: {"content": content, "post_id": post_id.toString(), "user_id": user_id.toString()});
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> removeComment(int comment_id) async {
    String url = AppConfig.URL_REMOVE_COMMENT;
    final response = await http.delete(url + comment_id.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }
}
