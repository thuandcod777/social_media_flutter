import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_flutter/model/message.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class ChatService {
  sendMessage(Message message, String chatId) async {
    //will send message to chats collection with the usersId
    await chatRef.doc("chatId").collection("messages").add(message.toJson());
    //will update "lastTextTime" to the last time a text was sent
    //await chatRef.doc("chatId").update({"lastTextTime": Timestamp.now()});
  }

  Future<String> sendFirstMessage(Message message, String recipient) async {
    User user = firebaseAuth.currentUser;
    DocumentReference ref = await chatRef.add({
      'users': [recipient, user.uid],
    });

    await sendMessage(message, ref.id);
    return ref.id;
  }

  /*setUserRead(String chatId, User user, int count) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    Map reads = snap.get('reads') ?? {};
    reads[user.uid] = count;
    await chatRef.doc(chatId).update({'reads': reads});
  }*/

  /*setUserTyping(String chatId, User user, bool userTyping) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    Map typing = snap.get('typing') ?? {};
    typing[user.uid] = userTyping;
    await chatRef.doc(chatId).update({'typing': typing});
  }*/
}
