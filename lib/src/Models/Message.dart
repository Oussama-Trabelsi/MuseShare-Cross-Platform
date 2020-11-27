
class Message {
  int id;
  String content;
  String status;
  DateTime date;

  Message({this.id, this.content, this.status, this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      status: json['status'],
      date: DateTime.parse(json["date"]),
    );
  }
}


