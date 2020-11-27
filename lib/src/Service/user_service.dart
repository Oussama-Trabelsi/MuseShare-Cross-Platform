import 'dart:convert';
import 'package:flutter_login_signup/src/Config/AppConfig.dart';
import 'package:flutter_login_signup/src/Models/User.dart';
import 'package:http/http.dart' as http;

class UserWebService {

  Future<User> login(var username, var password) async {
    var params = {"username": username, "password": password};

    String url = AppConfig.URL_SIGNIN;
    final response = await http.post(url, body: params);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      return User.fromJson(body["user"]);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<User> register(var username, var firstName, var lastName, var password, var email) async {
    var params = {
      "username": username,
      "firstname": firstName,
      "lastname": lastName,
      "password": password,
      "email": email
    };

    String url = AppConfig.URL_REGISTER;
    final response = await http.post(url, body: params);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      return User.fromJsonArray(body["user"]);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<bool> followUser(int user_id, int followed_user_id) async {
    String url = AppConfig.URL_FOLLOW;
    final response = await http.post(url + user_id.toString() + "/" + followed_user_id.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> unfollowUser(int user_id, int followed_user_id) async {
    String url = AppConfig.URL_UNFOLLOW;
    final response = await http.delete(url + user_id.toString() + "/" + followed_user_id.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<List<User>> searchUser(String param) async {
    String url = AppConfig.URL_SEARCH;
    final response = await http.get(url + param);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<User> users = body
          .map(
            (dynamic item) => User.fromJsonArray(item),
      ).toList();
      return users;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<User> findOne(int id) async {
    String url = AppConfig.URL_FIND_ONE;
    final response = await http.get(url + id.toString());
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      return User.fromJson(body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }


}
