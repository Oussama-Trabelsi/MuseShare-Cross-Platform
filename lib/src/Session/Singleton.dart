import 'package:flutter_login_signup/src/Models/User.dart';

class Singleton {
  static Singleton _instance;

  User user;

  User get logged_in_user => user;
  set logged_in_user(User user) {
    this.user = user;
  }

  factory Singleton() {
    return _instance;
  }

  Singleton._internal(){}

  static Singleton getState(){
    if(_instance == null){
      _instance = Singleton._internal();
    }

    return _instance;
  }
}