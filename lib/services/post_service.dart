import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_flutter/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_flutter/services/service.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class PostService extends Service {
  uploadProfilePicture(File image, User user) async {
    String link = await uploadImage(profilePic, image);
    var ref = usersRef.doc(user.uid);
    ref.update({"photoUrl": link});
  }

  uploadPost(File image, String location, String description) async {
    String link = await uploadImage(posts, image);
    DocumentSnapshot doc =
        await usersRef.doc(firebaseAuth.currentUser.uid).get();
    Users user = Users.fromJson(doc.data());
    var ref = postRef.doc();
    ref.set({
      "id": ref.id,
      "postId": ref.id,
      "username": user.username,
      "ownerId": firebaseAuth.currentUser.uid,
      "mediaUrl": link,
      "description": description ?? "",
      "location": location ?? "",
      "timestamp": Timestamp.now(),
    }).catchError((e) {
      print(e);
    });
  }

  uploadComment(String currentUserId, String comment, String postId,
      String ownerId, String mediaPostUrl) async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId).get();
    Users user = Users.fromJson(doc.data());
    await commentRef.doc(postId).collection("comments").add({
      "username": user.username,
      "comment": comment,
      "timestamp": Timestamp.now(),
      "userDp": user.photoUrl,
      "userId": user.id,
    });
  }
}
