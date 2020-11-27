class ImagePost {
  final int albumId;
  final int id;
  final String title;
  final String thumbnailUrl;
  final String url;

  ImagePost({this.albumId, this.id, this.title,this.thumbnailUrl,this.url});

  factory ImagePost.fromJson(Map<String, dynamic> json) {
    return ImagePost(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      url: json['url'],

    );
  }
}


