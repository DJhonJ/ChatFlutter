import 'package:firebase_database/firebase_database.dart';

class AppUser {
  String? key;
  String email;
  String uid;
  bool loggedIn;

  AppUser(this.key, this.email, this.uid, this.loggedIn);

  AppUser.fromJson(DataSnapshot snapshot, Map<dynamic, dynamic> json)
      : key = snapshot.key ?? "0",
        email = json['email'] ?? "email",
        uid = json['uid'] ?? "uid",
        loggedIn = json['logged'] ?? false;

  toJson() {
    return {
      "email": email,
      "uid": uid,
    };
  }
}
