import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/person_profile/person_profile.dart';
import 'package:social_media_flutter/services/authentication.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';
//import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
  TextEditingController updateCaptionController = TextEditingController();

  /*String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }*/

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: constantColors.whiteColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.greyColor,
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(FontAwesomeIcons.edit,
                                  color: constantColors.lightColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Update Caption'),
                                        content: TextField(
                                          decoration: InputDecoration(
                                              hintText: 'Add New Caption',
                                              hintStyle: TextStyle(
                                                  color:
                                                      constantColors.darkColor,
                                                  fontSize: 17.0)),
                                          controller: updateCaptionController,
                                        ),
                                        actions: [
                                          GestureDetector(
                                            child: Text('Cancel'),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .updateCaption(postId, {
                                                'caption':
                                                    updateCaptionController.text
                                              }).whenComplete(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text(
                                              'Update',
                                              style: TextStyle(
                                                  color:
                                                      constantColors.blueColor),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'Edit Caption',
                                style:
                                    TextStyle(color: constantColors.lightColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.0,
                        color: constantColors.greyColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.trashAlt,
                                color: constantColors.lightColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Delete this Post ?',
                                          style: TextStyle(
                                              color: constantColors.lightColor),
                                        ),
                                        actions: [
                                          GestureDetector(
                                            child: Text('No',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .lightColor)),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Provider.of<FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .deleteUserData(
                                                        postId, 'posts')
                                                    .whenComplete(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .blueColor),
                                              ))
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'Delete',
                                style:
                                    TextStyle(color: constantColors.lightColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getinitUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.79,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.greyColor,
                  ),
                ),
                Container(
                  height: 40.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.greyColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        color: constantColors.lightColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(docId)
                        .collection('comments')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  child: PersonProfile(
                                                      userUid: documentSnapshot[
                                                          'useruid']),
                                                  type: PageTransitionType
                                                      .bottomToTop));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              constantColors.darkColor,
                                          radius: 15.0,
                                          backgroundImage: NetworkImage(
                                              documentSnapshot['userimage']),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Text(
                                                      documentSnapshot[
                                                          'username'],
                                                      style: TextStyle(
                                                          color: constantColors
                                                              .darkColor,
                                                          fontSize: 12.0)),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.arrowUp,
                                                  color:
                                                      constantColors.blueColor,
                                                ),
                                                onPressed: () {}),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color:
                                                      constantColors.darkColor,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.reply,
                                                  color: constantColors
                                                      .yellowColor,
                                                ),
                                                onPressed: () {}),
                                            IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color:
                                                      constantColors.redColor,
                                                ),
                                                onPressed: () {})
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: constantColors.blueColor,
                                            size: 12.0,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Container(
                                          child: Text(
                                            documentSnapshot['comment'],
                                            style: TextStyle(
                                                color:
                                                    constantColors.darkColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50.0,
                          width: 300.0,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Add Comment',
                              hintStyle:
                                  TextStyle(color: constantColors.greyColor),
                            ),
                            controller: commentController,
                            style: TextStyle(
                              color: constantColors.darkColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                            backgroundColor: constantColors.whiteColor,
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constantColors.lightColor,
                            ),
                            onPressed: () {
                              print('Adding comment....');
                              addComment(context, snapshot['caption'],
                                      commentController.text)
                                  .whenComplete(() {
                                commentController.clear();
                                notifyListeners();
                              });
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          ));
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.greyColor,
                  ),
                ),
                Container(
                  height: 40.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.greyColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                        color: constantColors.lightColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return new ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: PersonProfile(
                                                userUid: documentSnapshot[
                                                    'useruid']),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userimage']),
                                  ),
                                ),
                                title: Text(
                                  documentSnapshot['username'],
                                  style: TextStyle(
                                      color: constantColors.darkColor),
                                ),
                                subtitle: Text(
                                  documentSnapshot['useremail'],
                                  style: TextStyle(
                                      color: constantColors.darkColor),
                                ),
                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot['useruid']
                                    ? Container(height: 0.0, width: 0.0)
                                    : MaterialButton(
                                        color: constantColors.blueColor,
                                        onPressed: () {},
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                          ),
                                        ),
                                      ));
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.whiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
            ),
          );
        });
  }

  showRewards(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.greyColor,
                  ),
                ),
                Container(
                    height: 40.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.greyColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                        child: Text(
                      'Rewards',
                      style: TextStyle(color: constantColors.lightColor),
                    ))),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('awards')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () async {
                                print('Rewarding user.......');
                                await Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .addAdward(postId, {
                                  'username': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getinitUserName,
                                  'userimage': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getinitUserImage,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  'time': Timestamp.now(),
                                  'award': documentSnapshot['image'],
                                });
                              },
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                child: Image.network(
                                  documentSnapshot['image'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.whiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
            ),
          );
        });
  }

  showAwardsPresenter(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.greyColor,
                  ),
                ),
                Container(
                  height: 40.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.greyColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      'Award Socialites',
                      style: TextStyle(color: constantColors.lightColor),
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('awards')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: PersonProfile(
                                            userUid:
                                                documentSnapshot['useruid']),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(documentSnapshot['userimage']),
                                radius: 15.0,
                              ),
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: TextStyle(color: constantColors.darkColor),
                            ),
                            trailing: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid ==
                                    documentSnapshot['useruid']
                                ? Container(height: 0.0, width: 0.0)
                                : MaterialButton(
                                    color: constantColors.blueColor,
                                    onPressed: () {},
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                      ),
                                    ),
                                  ),
                          );
                        }).toList());
                      }
                    },
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }
}
