import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String type;
  String username;
  String userId;
  String userDp;
  String postId;
  String mediaPostUrl;
  String commentData;
  Timestamp timestamp;

  ActivityModel({
    this.type,
    this.username,
    this.userId,
    this.userDp,
    this.postId,
    this.mediaPostUrl,
    this.commentData,
    this.timestamp,
  });

  ActivityModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    username = json['username'];
    userId = json['userId'];
    userDp = json['userDp'];
    mediaPostUrl = json['mediaPostUrl'];
    commentData = json['commentData'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['username'] = this.type;
    data['userId'] = this.type;
    data['userDp'] = this.type;
    data['mediaPostUrl'] = this.type;
    data['commentData'] = this.type;
    data['timestamp'] = this.type;

    return data;
  }
}
