import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/person_profile/person_profile.dart';
import 'package:social_media_flutter/services/authentication.dart';
import 'package:social_media_flutter/utils/post_functions.dart';
import 'package:social_media_flutter/utils/upload_post.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedHelper with ChangeNotifier {
  ConstantColors constrainedColor = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constrainedColor.whiteColor,
          ),
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false)
                .selectPostImageType(context);
          },
        )
      ],
      backgroundColor: constrainedColor.blueGreyColor,
      title: RichText(
        text: TextSpan(
            text: 'Social',
            style: TextStyle(
                color: constrainedColor.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                text: ' Media',
                style: TextStyle(
                    color: constrainedColor.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              )
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 500.0,
              width: 400.0,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: loadPosts(context, snapshot),
          );
        }
      },
    );
  }

  Widget loadPosts(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) {
    return ListView(
      children: snapshot.data.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (document['useruid'] !=
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid) {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: PersonProfile(
                                    userUid: document['useruid'],
                                  ),
                                  type: PageTransitionType.bottomToTop));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CircleAvatar(
                          backgroundColor: constrainedColor.transperant,
                          radius: 20.0,
                          backgroundImage: NetworkImage(data['userimage']),
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              child: Text(
                                data['username'],
                                style: TextStyle(
                                    color: constrainedColor.darkColor,
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                                child: Text(
                              timeago.format(data['time'].toDate()),
                              style: TextStyle(
                                  color: constrainedColor.darkColor,
                                  fontSize: 10.0),
                            )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 90.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.34,
                        height: 40.0,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(document['caption'])
                              .collection('awards')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return new ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot documentSnapshot) {
                                    return Container(
                                      height: 50.0,
                                      width: 50.0,
                                      child: Image.network(
                                          documentSnapshot['award']),
                                    );
                                  }).toList());
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text(
                          data['caption'],
                          style: TextStyle(color: constrainedColor.darkColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.46,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.network(
                      data['postimage'],
                      scale: 2,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  FontAwesomeIcons.heart,
                                  color: constrainedColor.redColor,
                                  size: 22.0,
                                ),
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .addLike(
                                          context,
                                          document['caption'],
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid);
                                },
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(document['caption'])
                                    .collection('likes')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Provider.of<PostFunctions>(context,
                                                  listen: false)
                                              .showLikes(
                                                  context, document['caption']);
                                        },
                                        child: Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constrainedColor.darkColor,
                                              fontSize: 17.0),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  FontAwesomeIcons.comment,
                                  color: constrainedColor.blueColor,
                                  size: 22.0,
                                ),
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showCommentSheet(context, document,
                                          document['caption']);
                                },
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(document['caption'])
                                    .collection('comments')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                        /*onTap: () {
                                                  Provider.of<PostFunctions>(context,
                                                          listen: false)
                                                      .showLikes(
                                                          context, document['caption']);
                                                },*/
                                        child: Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constrainedColor.darkColor,
                                              fontSize: 17.0),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showRewards(
                                          context, document['caption']);
                                },
                                child: Icon(
                                  FontAwesomeIcons.award,
                                  color: constrainedColor.yellowColor,
                                  size: 22.0,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(document['caption'])
                                    .collection('awards')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Provider.of<PostFunctions>(context,
                                                  listen: false)
                                              .showAwardsPresenter(
                                                  context, document['caption']);
                                        },
                                        child: Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constrainedColor.darkColor,
                                              fontSize: 17.0),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 101.0),
                    child: Provider.of<Authentication>(context, listen: false)
                                .getUserUid ==
                            data['useruid']
                        ? IconButton(
                            icon: Icon(
                              EvaIcons.moreVertical,
                              color: constrainedColor.darkColor,
                            ),
                            onPressed: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showPostOptions(
                                      context, document['caption']);
                            })
                        : Container(
                            width: 0.0,
                            height: 0.0,
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
