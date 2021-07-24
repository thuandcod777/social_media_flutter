import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/user.dart';
import 'package:social_media_flutter/screens/login/login.dart';
import 'package:social_media_flutter/screens/widget/button_widget.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'profile_screen';
  final profileId;

  ProfileScreen({this.profileId, Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isToggle = false;
  User user;
  bool isFollowing = false;

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  void initState() {
    checkIfFollowing();
    super.initState();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get();

    setState(() {
      isFollowing = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text('Person'),
        actions: [
          widget.profileId == firebaseAuth.currentUser.uid
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        firebaseAuth.signOut();
                        Navigator.pushReplacementNamed(context, Login.id);
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: Colors.white,
            floating: false,
            collapsedHeight: 6.0,
            toolbarHeight: 5.0,
            expandedHeight: 320.0,
            flexibleSpace: FlexibleSpaceBar(
              background: StreamBuilder(
                stream: usersRef.doc(widget.profileId).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromJson(snapshot.data.data());
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Container(
                                height: 100.0,
                                width: 100.0,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(user.photoUrl),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      user.username,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(user.country,
                                        style: TextStyle(color: Colors.black)),
                                    Text(user.email,
                                        style: TextStyle(color: Colors.black))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('0',
                                        style: TextStyle(color: Colors.black)),
                                    Text(
                                      'Posts'.toUpperCase(),
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('0',
                                        style: TextStyle(color: Colors.black)),
                                    Text(
                                      'Followers'.toUpperCase(),
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('0',
                                        style: TextStyle(color: Colors.black)),
                                    Text(
                                      'Followings'.toUpperCase(),
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        buildProfileButton(),
                      ],
                    );
                  }

                  return Container();
                },
              ),
            ),
          ),
          SliverList(delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index > 0) return null;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      'All Posts',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.grey),
                    ),
                    Spacer(),
                    buildIcons(),
                  ],
                ),
              ),
            ]);
          }))
        ],
      ),
    );
  }

  buildIcons() {
    if (isToggle) {
      return IconButton(
          icon: Icon(
            Icons.list,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isToggle = false;
            });
          });
    } else if (isToggle == false) {
      return IconButton(
          icon: Icon(
            Icons.grid_on,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isToggle = true;
            });
          });
    }
  }

  buildProfileButton() {
    bool isMe = widget.profileId == firebaseAuth.currentUser.uid;

    if (isMe) {
      return GestureDetector(
          onTap: () {
            handleUnfollow();
          },
          child: Container(
              height: 40.0,
              width: 170.0,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              )));
      /*return ButtonCustom(
        text: 'Edit Profile',
        callback: () {},
      );*/
    } else if (isFollowing) {
      return GestureDetector(
          onTap: () {
            handleUnfollow();
          },
          child: Container(
              height: 40.0,
              width: 170.0,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Center(
                child: Text(
                  'Unfollow',
                  style: TextStyle(color: Colors.white),
                ),
              )));

      /* return ButtonCustom(
        text: 'UnFollow',
        callback: () => handleUnfollow(),
      );*/
    } else if (!isFollowing) {
      return GestureDetector(
          onTap: () {
            handleFollow();
          },
          child: Container(
              height: 40.0,
              width: 170.0,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Center(
                child: Text(
                  'Follow',
                  style: TextStyle(color: Colors.white),
                ),
              )));
      /*return ButtonCustom(
        text: 'Follow',
        callback: () => handleFollow()(),
      );*/
    }
  }

  handleFollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    // UserModel users = UserModel.fromJson(doc.data());

    setState(() {
      isFollowing = true;
    });

    followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .set({});
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
  }

  handleUnfollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    // UserModel users = UserModel.fromJson(doc.data());

    followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
      setState(() {
        isFollowing = false;
      });
    });
  }
}
