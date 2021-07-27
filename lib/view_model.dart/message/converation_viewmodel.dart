import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/message.dart';
import 'package:social_media_flutter/services/chat_service.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class ConversationViewModel extends ChangeNotifier {
  ChatService chatService = ChatService();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  sendMessage(String chatId, Message message) {
    chatService.sendMessage(message, chatId);
  }

  Future<String> sendFirstMessage(String recipient, Message message) async {
    String newChatId = await chatService.sendFirstMessage(message, recipient);
    return newChatId;
  }

  /*setReadCount(String chatId, var user, int count) {
    chatService.setUserRead(chatId, user, count);
  }*/

  /*setUserTyping(String chatId, var user, bool typing) {
    chatService.setUserTyping(chatId, user, typing);
  }*/

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }
}
