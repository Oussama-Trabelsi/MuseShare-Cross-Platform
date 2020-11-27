
import 'package:flutter_login_signup/src/Models/Message.dart';

import 'User.dart';

class Conversation {
  int id;
  User first_user;
  User second_user;
  List<Message> messages;

  Conversation({this.id, this.first_user, this.second_user, this.messages});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var messages = new List<Message>();
    if(json["messagesCount"] as int > 0) {
      messages =  List<Message>.from(json["messages"].map(
            (dynamic item) => Message.fromJson(item),
      ));
    }
    return Conversation(
      id: json['id'],
      first_user: User.fromJsonArray(json['first_user']),
      second_user: User.fromJsonArray(json['second_user']),
      messages: messages,
    );
  }
}


