import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/landing_page.dart/lading_page.dart';
import 'package:social_media_flutter/screens/person_profile/person_profile.dart';
import 'package:social_media_flutter/services/authentication.dart';

class ProfileHelpers with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Widget headerProfile(BuildContext context, dynamic snapshot) {
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
                  backgroundImage:
                      NetworkImage(snapshot.data.data()['userimage']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  snapshot.data.data()['username'],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  snapshot.data.data()['useremail'],
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
              Container(
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
                            style: TextStyle(color: constantColors.whiteColor),
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
              GestureDetector(
                onTap: () {
                  checkFollowingSheet(context, snapshot);
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
        )
      ],
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 150.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesomeIcons.userAstronaut,
                color: constantColors.yellowColor,
                size: 16.0,
              ),
              Text(
                'Recently Added',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: constantColors.darkColor),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.0)),
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

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Log Out Of theSocial?',
              style: TextStyle(
                  color: constantColors.darkColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.redColor,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .signOutWithEmail()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: LandingPage(),
                              type: PageTransitionType.bottomToTop));
                    });
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
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
                      'Following',
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
                        .collection('following')
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
                                          'UnFollow',
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
