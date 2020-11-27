
class User {
  int user_id;
  String username;
  String user_firstName;
  String user_lastName;
  String user_email;
  String user_password;
  String user_bio;
  String profileImageUrl;
  bool isPrivate;
  bool isOnline;
  DateTime last_login;
  List<User> followers;
  List<User> following;
  int followersCount;
  int followingCount;
  int postsCount;

  User();
  User.registerModel(this.username, this.user_firstName, this.user_lastName, this.user_email, this.user_password);
  User.relationUser({this.user_id, this.username, this.user_firstName, this.user_lastName, this.user_email, this.user_password, this.user_bio, this.profileImageUrl,
    this.isPrivate, this.isOnline, this.last_login, this.followersCount, this.followingCount, this.postsCount});
  User.fullUser({this.user_id, this.username, this.user_firstName, this.user_lastName, this.user_email, this.user_password, this.user_bio, this.profileImageUrl,
      this.isPrivate, this.isOnline, this.last_login, this.followers, this.following, this.followersCount, this.followingCount, this.postsCount});

  factory User.fromJson(Map<String, dynamic> json) {
    var followers = List<User>.from(json["followers"].map(
          (dynamic item) => User.fromJsonArray(item),
    ));
    var following = List<User>.from(json["followers"].map(
          (dynamic item) => User.fromJsonArray(item),
    ));
    return User.fullUser(
        user_id: json['user_id'],
        username: json['username'],
        user_firstName: json['user_firstName'],
        user_lastName: json['user_lastName'],
        user_email: json['user_email'],
        user_password: json['user_password'],
        user_bio: json['user_bio'],
        profileImageUrl: json['profileImgUrl'],
        isPrivate: json['isPrivate'],
        isOnline: json['isOnline'],
        last_login: DateTime.parse(json['last_login']),
        followers: followers,
        following: following,
        followersCount: json['followersCount'],
        followingCount: json['followingCount'],
        postsCount: json['postsCount'],
    );
  }

  factory User.fromJsonArray(Map<String, dynamic> json) {
    return User.relationUser(
      user_id: json['user_id'],
      username: json['username'],
      user_firstName: json['user_firstName'],
      user_lastName: json['user_lastName'],
      user_email: json['user_email'],
      user_password: json['user_password'],
      user_bio: json['user_bio'],
      profileImageUrl: json['profileImgUrl'],
      isPrivate: json['isPrivate'],
      isOnline: json['isOnline'],
      last_login: DateTime.parse(json['last_login']),
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
      postsCount: json['postsCount'],
    );
  }
}