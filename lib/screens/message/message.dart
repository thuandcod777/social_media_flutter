import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_flutter/model/user.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> filteredUsers = [];
  List<DocumentSnapshot> users = [];
  User user;
  bool loading = true;
  currentUserId() {
    firebaseAuth.currentUser.uid;
  }

  getUsers() async {
    QuerySnapshot snap = await followingRef.get();
    List<DocumentSnapshot> doc = snap.docs;
    users = doc;
    filteredUsers = doc;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  removeFromList(index) {
    return filteredUsers.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: buildSearch(),
      ),
      body: buildUser(),
    );
  }

  buildSearch() => Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Center(
            child: TextFormField(
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          textCapitalization: TextCapitalization.sentences,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          inputFormatters: [
            LengthLimitingTextInputFormatter(20),
          ],
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                searchController.clear();
              },
              child: Icon(Icons.delete, size: 12.0, color: Colors.black),
            ),
            contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
        )),
      ));

  buildUser() {
    return ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot doc = filteredUsers[index];
          UserModel user = UserModel.fromJson(doc.data());
          if (doc.id == currentUserId()) {
            Timer(Duration(milliseconds: 500), () {
              setState(() {
                removeFromList(index);
              });
            });
          }
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 35.0,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                title: Text(
                  user.username,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(user.email),
              )
            ],
          );
        });
  }
}
