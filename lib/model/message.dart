import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_flutter/model/enum/message_type.dart';

class Message {
  String content;
  String senderUid;
  MessageType type;
  Timestamp time;

  Message({this.content, this.senderUid, this.type, this.time});

  Message.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    senderUid = json['senderUid'];
    if (json['type'] == 'text') {
      type = MessageType.TEXT;
    }
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['senderUid'] = this.senderUid;
    if (this.type == MessageType.TEXT) {
      data['type'] = 'text';
    }

    data['time'] = this.time;
    return data;
  }
}
