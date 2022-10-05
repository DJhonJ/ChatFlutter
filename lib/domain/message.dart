import 'package:firebase_database/firebase_database.dart';

class Message {
  String? key;
  String msg;
  String senderUid;
  String? date;

  Message(this.key, this.msg, this.senderUid);

  Message.fromJson(DataSnapshot snapshot, Map<dynamic, dynamic> json)
      : key = snapshot.key,
        senderUid = json['senderUid'] ?? "senderUid",
        msg = json["msg"] ?? "msug",
        date = json["date"] ?? "";

  Message.fromJson2(String? _key, Map<dynamic, dynamic> json)
      : key = _key,
        senderUid = json['senderUid'] ?? "senderUid",
        msg = json["msg"] ?? "msug",
        date = json["date"] ?? "";

  toJson() {
    return {
      "msg": msg,
      "senderUid": senderUid,
    };
  }
}
