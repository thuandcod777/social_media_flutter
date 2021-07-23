import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String photoUrl;
  String country;
  String email;
  Timestamp singnedUpAt;
  bool isOnline;
  String id;

  UserModel(
      {this.username,
      this.singnedUpAt,
      this.email,
      this.photoUrl,
      this.country,
      this.isOnline,
      this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    singnedUpAt = json['singnedUpAt'];
    photoUrl = json['photoUrl'];
    country = json['country'];
    isOnline = json['isOnline'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['username'] = this.username;
    data['singnedUpAt'] = this.singnedUpAt;
    data['photoUrl'] = this.photoUrl;
    data['country'] = this.country;
    data['isOnline'] = this.isOnline;
    data['email'] = this.email;
    data['id'] = this.id;

    return data;
  }
}
