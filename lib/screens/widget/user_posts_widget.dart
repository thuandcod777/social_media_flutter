import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:social_media_flutter/model/comment.dart';
import 'package:social_media_flutter/model/post.dart';
import 'package:social_media_flutter/model/user.dart';
import 'package:social_media_flutter/screens/profile/profile.dart';
import 'package:social_media_flutter/screens/viewimage/view_image_screen.dart';
import 'package:social_media_flutter/screens/widget/custom_card.dart';
import 'package:social_media_flutter/screens/widget/custom_image.dart';
import 'package:social_media_flutter/screens/widget/stream_comment_wrapper.dart';
import 'package:social_media_flutter/services/post_service.dart';
import 'package:social_media_flutter/utils/firebase.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPost extends StatelessWidget {
  final PostModel post;
  UserPost({this.post});

  final DateTime timestamp = DateTime.now();

  TextEditingController commentsTEC = TextEditingController();

  PostService service = PostService();

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: null,
      borderRadius: BorderRadius.circular(10.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return ViewImageScreen(
            post: post,
          );
        },
        closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUser(context),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Visibility(
                      visible: post.description != null &&
                          post.description.toString().isNotEmpty,
                      child: Text(
                        '${post.description ?? ""}',
                        maxLines: 2,
                      ),
                    ),
                  ),
                  ClipRRect(
                    child: CustomImage(
                      imageUrl: post?.mediaPostUrl ?? '',
                      height: 300.0,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  builLikeButton()
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  builLikeButton() {
    return StreamBuilder(
      stream: likesRef
          .where('postId', isEqualTo: post.postId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<QueryDocumentSnapshot> docs = snapshot.data.docs ?? [];
        if (snapshot.hasData) {
          return Row(
            children: [
              IconButton(
                  icon: docs.isEmpty
                      ? Icon(CupertinoIcons.heart)
                      : Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                        ),
                  onPressed: () {
                    if (docs.isEmpty) {
                      likesRef.add({
                        'userId': currentUserId(),
                        'postId': post.postId,
                        'dateCreated': Timestamp.now()
                      });
                      addLikeToNotification();
                    } else {
                      likesRef.doc(docs[0].id).delete();
                    }
                  }),
              StreamBuilder(
                  stream: likesRef
                      .where('postId', isEqualTo: post.postId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot snap = snapshot.data;
                      List<DocumentSnapshot> docs = snap.docs;
                      return buildLikeCount(context, docs.length ?? 0);
                    } else {
                      return buildLikeCount(context, 0);
                    }
                  }),
              IconButton(
                  icon: Icon(CupertinoIcons.chat_bubble),
                  onPressed: () {
                    buildComment(context);
                  }),
              StreamBuilder(
                  stream: commentRef
                      .doc(post.postId)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot snap = snapshot.data;
                      List<DocumentSnapshot> docs = snap.docs;
                      return buildCommentCount(context, docs.length ?? 0);
                    } else {
                      return buildCommentCount(context, 0);
                    }
                  }),
              //buildLikeCountTest(context)
            ],
          );
        }
        return Container();
      },
    );
  }

  /*buildLikeCountTest(BuildContext context) {
    return StreamBuilder(
        stream: likesRef.where('postId', isEqualTo: post.postId).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot snap = snapshot.data;
            List<DocumentSnapshot> docs = snap.docs;
            int count = docs.length;
            return Text('$count');
          }
          return Container();
        });
  }*/

  buildComment(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.91,
            child: Column(
              children: [
                Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: CommentStreamWrapper(
                    shrinkWrap: true,
                    stream: commentRef
                        .doc(post.postId)
                        .collection('comments')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, DocumentSnapshot snapshot) {
                      CommentModel comments =
                          CommentModel.fromJson(snapshot.data());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              backgroundImage: NetworkImage(comments.userDp),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(comments.username),
                                        Text(comments.comment),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                    timeago.format(comments.timestamp.toDate()))
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: 'Write your comment...'),
                        maxLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        controller: commentsTEC,
                      ),
                      trailing: GestureDetector(
                          onTap: () async {
                            await service.uploadComment(
                                currentUserId(),
                                commentsTEC.text,
                                post.postId,
                                post.ownerId,
                                post.mediaPostUrl);
                            commentsTEC.clear();
                          },
                          child: Icon(Icons.send)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildLikeCount(BuildContext context, int count) {
    return Text('$count');
  }

  buildCommentCount(BuildContext context, int count) {
    return Text('$count -comment');
  }

  buildUser(BuildContext context) {
    // bool isMe = currentUserId() == post.ownerId;

    return StreamBuilder(
        stream: usersRef.doc(post.ownerId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Users user = Users.fromJson(snapshot.data.data());
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: GestureDetector(
                  onTap: () => showProfile(context, profileId: user.id),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.photoUrl.isNotEmpty
                            ? CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Colors.black,
                                backgroundImage: CachedNetworkImageProvider(
                                    user?.photoUrl ?? ""),
                              )
                            : CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Colors.black,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${post.username ?? ""}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  post.location == null
                                      ? Container()
                                      : RichText(
                                          text: TextSpan(
                                              text: ' - at ',
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                                TextSpan(
                                                    text: post.location,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                        ),
                                ],
                              ),
                              Text(timeago.format(post.timestamp.toDate())),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return Container();
        });
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => ProfileScreen(profileId: profileId),
        ));
  }

  addLikeToNotification() async {
    bool isNotMe = currentUserId() != post.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      Users user = Users.fromJson(doc.data());
      service.addLikesToNotification("likes", user.username, currentUserId(),
          post.postId, post.mediaPostUrl, post.ownerId, user.photoUrl);
    }
  }
}
