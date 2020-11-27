import 'User.dart';

class Post {
  int id;
  String description;
  String trackUrl;
  String iconUrl;
  String trackName;
  DateTime date;
  User user;
  List<User> likes;
  int likesCount;
  int commentsCount;

  Post({this.id, this.description, this.trackUrl, this.iconUrl, this.trackName, this.date, this.user, this.likes, this.likesCount, this.commentsCount});

  factory Post.fromJson(Map<String, dynamic> json) {
    var likes = new List<User>();
    if(json["likesCount"] as int > 0) {
      likes =  List<User>.from(json["likes"].map(
            (dynamic item) => User.fromJsonArray(item),
      ));
    }
    return Post(
      id: json["id"],
      description: json["description"],
      trackUrl: json["trackUrl"],
      iconUrl: json["iconUrl"],
      trackName: json["trackname"],
      date: DateTime.parse(json["date"]),
      user: User.fromJsonArray(json["user"]),
      likes: likes,
      likesCount: json["likesCount"],
      commentsCount: json["commentsCount"],
    );
  }
}