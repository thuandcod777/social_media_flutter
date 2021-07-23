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
    UserModel user = UserModel.fromJson(doc.data());
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
    UserModel user = UserModel.fromJson(doc.data());
    await commentRef.doc(postId).collection("comments").add({
      "username": user.username,
      "comment": comment,
      "timestamp": Timestamp.now(),
      "userDp": user.photoUrl,
      "userId": user.id,
    });

    bool isNotMe = ownerId != currentUserId;
    if (isNotMe) {
      addCommentToNotification("comment", comment, user.username, user.id,
          postId, mediaPostUrl, ownerId, user.photoUrl);
    }
  }

  addLikesToNotification(String type, String username, String userId,
      String postId, String mediaPostUrl, String ownerId, String userDp) async {
    await notificationRef
        .doc(ownerId)
        .collection('notifications')
        .doc(postId)
        .set({
      "type": type,
      "username": username,
      "userId": firebaseAuth.currentUser.uid,
      "userDp": userDp,
      "postId": postId,
      "mediaPostUrl": mediaPostUrl,
      "timestamp": Timestamp.now(),
    });
  }

  addCommentToNotification(
      String type,
      String commentData,
      String username,
      String userId,
      String postId,
      String mediaPostUrl,
      String ownerId,
      String userDp) async {
    await notificationRef.doc(ownerId).collection('notifications').add({
      "type": type,
      "commentData": commentData,
      "username": username,
      "userId": userId,
      "userDp": userDp,
      "ownerId": ownerId,
      "postId": postId,
      "mediaPostUrl": mediaPostUrl,
      "timestamp": Timestamp.now(),
    });
  }
}
