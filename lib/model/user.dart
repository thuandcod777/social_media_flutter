import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String userid;
  String username;
  String userimage;
  Timestamp singnedUpAt;
  bool isOnline;

  Users(
      {this.userid,
      this.username,
      this.userimage,
      this.singnedUpAt,
      this.isOnline});

  Users.fromJson(Map<String, dynamic> json) {
    username = json['userimage'];
    singnedUpAt = json['singnedUpAt'];
    userimage = json['userimage'];
    isOnline = json['isOnline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['username'] = this.username;
    data['singnedUpAt'] = this.singnedUpAt;
    data['userimage'] = this.userimage;
    data['isOnline'] = this.isOnline;

    return data;
  }
}
