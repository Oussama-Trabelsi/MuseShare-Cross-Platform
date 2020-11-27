import 'User.dart';

class Comment {
  int id;
  String content;
  DateTime date;
  List<User> likes;
  User user;
  int likesCount;

  Comment({this.id, this.content, this.date, this.likes, this.user, this.likesCount});

  factory Comment.fromJson(Map<String, dynamic> json) {
    var likes = new List<User>();
    if(json["likesCount"] as int > 0) {
      likes =  List<User>.from(json["likes"].map(
            (dynamic item) => User.fromJsonArray(item),
      ));
    }
    return Comment(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json["date"]),
      likes: likes,
      user: User.fromJsonArray(json["user"]),
      likesCount: json['likesCount'],
    );
  }
}


