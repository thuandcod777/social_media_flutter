import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/model/message.dart';
import 'package:social_media_flutter/screens/widget/chat_item.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';
import 'package:social_media_flutter/view_model.dart/user/user_view_model.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class RecentChat extends StatelessWidget {
  const RecentChat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    viewModel.setUser();
    return Container(
      color: Colors.white,
      child: StreamBuilder(
          stream: userChatStream(viewModel.user.uid ?? ""),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List chatList = snapshot.data.docs;
              if (chatList.isNotEmpty) {
                return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot chatListSnapshot = chatList[index];
                      return StreamBuilder(
                          stream: messageListStream(chatListSnapshot.id),
                          builder: (context, snapshot) {
                            List messages = snapshot.data.docs;
                            Message message =
                                Message.fromJson(messages.first.data());

                            List users = chatListSnapshot.get('users');

                            users.remove('${viewModel.user.uid ?? ""}');

                            String recipient = users[0];

                            return ChatItem(
                                userId: recipient,
                                time: message.time,
                                msg: message.content,
                                messageCount: messages.length,
                                chatId: chatListSnapshot.id,
                                type: message.type,
                                currentUserId: viewModel.user.uid ?? "");
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Divider(),
                        ),
                      );
                    },
                    itemCount: chatList.length);
              } else {
                return Center(child: Text('No Chats'));
              }
            } else {
              return Center(child: circularProgress(context));
            }
          }),
    );
  }

  Stream<QuerySnapshot> userChatStream(String uid) {
    return chatRef
        .where('users', arrayContains: '$uid')
        .orderBy('lastTextTime', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> messageListStream(String documentId) {
    return chatRef
        .doc(documentId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
