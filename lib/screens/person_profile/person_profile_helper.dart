import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/home_page/home_page.dart';
import 'package:social_media_flutter/screens/person_profile/person_profile.dart';
import 'package:social_media_flutter/services/authentication.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';

class PersonProfileHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.fade));
          }),
      backgroundColor: constantColors.darkColor,
      actions: [
        IconButton(
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(), type: PageTransitionType.fade));
            })
      ],
      title: RichText(
        text: TextSpan(
            text: 'Person',
            style: TextStyle(color: constantColors.whiteColor, fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                  text: ' Profile',
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold))
            ]),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 200.0,
          width: 180.0,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  radius: 60.0,
                  backgroundImage: NetworkImage(snapshot.data['userimage']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  snapshot.data['username'],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  snapshot.data['useremail'],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  checkFollowersSheet(context, snapshot);
                },
                child: Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                      color: constantColors.darkColor,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(snapshot.data['useruid'])
                            .collection('followers')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return new Text(
                              snapshot.data.docs.length.toString(),
                              style:
                                  TextStyle(color: constantColors.whiteColor),
                            );
                          }
                        },
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                      color: constantColors.darkColor,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .doc(snapshot.data['useruid'])
                            .collection('following')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return new Text(
                              snapshot.data.docs.length.toString(),
                              style:
                                  TextStyle(color: constantColors.whiteColor),
                            );
                          }
                        },
                      ),
                      Text('Following', style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('3', style: TextStyle(color: Colors.white)),
                    Text('Posts', style: TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: constantColors.darkColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 30.0,
                        child: IconButton(
                            icon: Icon(
                              Icons.add_link,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .followUser(
                                      userUid,
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid,
                                      {
                                        'username':
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getinitUserName,
                                        'userimage':
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getinitUserImage,
                                        'useruid': Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserUid,
                                        'useremail':
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getinitUserEmail,
                                        'time': Timestamp.now(),
                                      },
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid,
                                      userUid,
                                      {
                                        'username': snapshot.data['username'],
                                        'userimage': snapshot.data['userimage'],
                                        'useremail': snapshot.data['useremail'],
                                        'useruid': snapshot.data['useruid'],
                                        'time': Timestamp.now(),
                                      })
                                  .whenComplete(() {
                                followedNotification(
                                    context, snapshot.data['username']);
                              });
                            })),
                    Text(
                      'Follow',
                      style: TextStyle(color: constantColors.whiteColor),
                    )
                  ],
                ),
              ),
              Container(
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: constantColors.darkColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 30.0,
                        child: IconButton(
                            icon: Icon(
                              Icons.message,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {})),
                    Text(
                      'Message',
                      style: TextStyle(color: constantColors.whiteColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        /*child: Image.asset(
          'assets/images/empty.png',
          fit: BoxFit.fill,
        ),*/
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(snapshot.data['useruid'])
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Image.asset('assets/images/empty.png', fit: BoxFit.fill);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return new GridView(
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Image.network(documentSnapshot['postimage']),
                      ),
                    ),
                  );
                }).toList(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              );
            }
          },
        ),
        height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                color: constantColors.whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.greyColor,
                  ),
                ),
                Text('Followed $name')
              ],
            ),
          );
        });
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
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
                      'Followers',
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
                        .collection('user')
                        .doc(snapshot.data['useruid'])
                        .collection('followers')
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
}
