import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/model/enum/message_type.dart';
import 'package:social_media_flutter/model/message.dart';
import 'package:social_media_flutter/model/user.dart';
import 'package:social_media_flutter/screens/widget/chat_bubble.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';
import 'package:social_media_flutter/utils/firebase.dart';
import 'package:social_media_flutter/view_model.dart/message/converation_viewmodel.dart';
import 'package:social_media_flutter/view_model.dart/user/user_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class Conversation extends StatefulWidget {
  //final String userId;
  final String chatId;
  final profileId;
  const Conversation({this.profileId, @required this.chatId});

  @override
  _Conversation createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  TextEditingController messageController = TextEditingController();
  bool isFirst = false;
  //String chatId;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      focusNode.unfocus();
    });

    /*if (widget.chatId == 'newChat') {
      isFirst = true;
    }*/
    //chatId = widget.chatId;

    /* messageController.addListener(() {
      if (focusNode.hasFocus && messageController.text.isNotEmpty) {
        setTyping(true);
      } else if (!focusNode.hasFocus ||
          (focusNode.hasFocus && messageController.text.isEmpty)) {
        setTyping(false);
      }
    });*/
  }

  /* setTyping(typing) {
    UserViewModel viewModel = Provider.of<UserViewModel>(context);
    viewModel.setUser();
    var user = Provider.of<UserViewModel>(context, listen: true).user;
    Provider.of<ConversationViewModel>(context, listen: false)
        .setUserTyping(widget.chatId, user, typing);
  }*/

  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel = Provider.of<UserViewModel>(context);
    viewModel.setUser();
    var user = Provider.of<UserViewModel>(context, listen: true).user;
    return Consumer<ConversationViewModel>(
        builder: (BuildContext context, viewModel, Widget child) {
      return Scaffold(
        key: viewModel.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_backspace),
          ),
          elevation: 0.0,
          titleSpacing: 0,
          title: buildUserName(),
        ),
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
                child: StreamBuilder(
                  stream: messageListStream(widget.chatId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List messages = snapshot.data.docs;
                      /*viewModel.setReadCount(
                          widget.chatId, user, messages.length);*/
                      return ListView.builder(
                          // controller: scrollController,
                          itemCount: messages.length,
                          reverse: true,
                          itemBuilder: (BuildContext context, int index) {
                            Message message = Message.fromJson(
                              messages.reversed.toList()[index].data(),
                            );

                            return ChatBubble(
                                message: '${message.content}',
                                time: message.time,
                                isMe: message.senderUid == user.uid,
                                type: message.type);
                          });
                    } else {
                      return Center(child: circularProgress(context));
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.black,
                          ),
                          onPressed: () {}),
                      Flexible(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: messageController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: "Type your message",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              sendMessage(viewModel, user);
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  sendMessage(ConversationViewModel viewModel, var user) async {
    String msg;
    msg = messageController.text.trim();
    messageController.clear();

    Message message = Message(
        content: '$msg',
        senderUid: user.uid,
        type: MessageType.TEXT,
        time: Timestamp.now());

    if (msg.isNotEmpty) {
      if (isFirst) {
        String id = await viewModel.sendFirstMessage(widget.profileId, message);
        setState(() {
          isFirst = false;
          // chatId = id;
        });
      } else {
        viewModel.sendMessage(widget.chatId, message);
      }
    }
  }

  buildUserName() {
    return StreamBuilder(
        stream: usersRef.doc(widget.profileId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            UserModel user = UserModel.fromJson(documentSnapshot.data());
            return InkWell(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Hero(
                      tag: user.email,
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundImage:
                            CachedNetworkImageProvider('${user.photoUrl}'),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.username),
                      StreamBuilder(
                          stream: chatRef.doc(widget.chatId).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              DocumentSnapshot snap = snapshot.data;
                              Map data = snap.data() ?? {};
                              Map usersTyping = data['typing'] ?? {};
                              return Text(
                                _buildOnlineText(user,
                                    usersTyping[widget.profileId] ?? false),
                                style: TextStyle(fontSize: 15.0),
                              );
                            } else {
                              return SizedBox();
                            }
                          })
                    ],
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _buildOnlineText(
    var user,
    bool typing,
  ) {
    if (user.isOnline) {
      if (typing) {
        return "typing....";
      } else {
        return "online";
      }
    } else {
      return 'last seen ${timeago.format(user.lastSeen.toDate())}';
    }
  }

  Stream<QuerySnapshot> messageListStream(String documentId) {
    return chatRef
        .doc("chatId")
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}
