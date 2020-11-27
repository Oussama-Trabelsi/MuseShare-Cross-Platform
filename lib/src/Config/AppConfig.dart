

class AppConfig{
  static String URL = "http://192.168.43.109:3000";

  /* User urls */
  static String URL_SIGNIN = URL + "/auth/login/";
  static String URL_REGISTER = URL + "/user/";
  static String URL_SEARCH = URL + "/user/search/";
  static String URL_FOLLOW = URL + "/user/follow/";
  static String URL_UNFOLLOW = URL + "/user/unfollow/";
  static String URL_FIND_ONE = URL + "/user/";

  /* Post urls */
  static String URL_ALL_POSTS = URL + "/post/";
  static String URL_USER_POSTS = URL + "/post/find/";
  static String URL_LIKE_POST = URL + "/post/like/";
  static String URL_DISLIKE_POST = URL + "/post/dislike/";

  /* Comment urls */
  static String URL_POST_COMMENTS = URL + "/comment/find/";
  static String URL_LIKE_COMMENT = URL + "/comment/like/";
  static String URL_DISLIKE_COMMENT = URL + "/comment/dislike/";
  static String URL_ADD_COMMENT = URL + "/comment/";
  static String URL_REMOVE_COMMENT = URL + "/comment/delete/";

  /* Chat urls */
  static String URL_USER_CONVERSATIONS = URL + "/conversation/find/";


  static String PROFILE_IMAGE_URL = URL + "/profile_images/";
  static String TRACK_URL = URL + "/tracks/";
}