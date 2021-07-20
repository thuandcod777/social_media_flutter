import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String postId;
  String ownerId;
  String username;
  String location;
  String description;
  String mediaPostUrl;
  Timestamp timestamp;

  PostModel(
      {this.id,
      this.postId,
      this.ownerId,
      this.username,
      this.location,
      this.description,
      this.mediaPostUrl,
      this.timestamp});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    ownerId = json['ownerId'];
    username = json['username'];
    location = json['location'];
    description = json['description'];
    mediaPostUrl = json['mediaUrl'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['ownerId'] = this.ownerId;
    data['username'] = this.username;
    data['location'] = this.location;
    data['description'] = this.description;
    data['mediaUrl'] = this.mediaPostUrl;
    data['timestamp'] = this.timestamp;

    return data;
  }
}
