import 'dart:convert';
import 'package:flutter_login_signup/src/Config/AppConfig.dart';
import 'package:flutter_login_signup/src/Models/Conversation.dart';
import 'package:http/http.dart' as http;

class ChatWebService {

  Future<List<Conversation>> fetchConversationsForUser(int user_id) async {
    String url = AppConfig.URL_USER_CONVERSATIONS;
    final response = await http.get(url + user_id.toString());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Conversation> conversations = body
          .map(
            (dynamic item) => Conversation.fromJson(item),
      ).toList();
      return conversations;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

}
