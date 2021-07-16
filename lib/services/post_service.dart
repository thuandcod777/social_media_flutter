import 'dart:developer';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_flutter/services/service.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class PostService extends Service {
  uploadProfilePicture(File image, User user) async {
    String link = await uploadImage(profilePic, image);
    var ref = usersRef.doc(user.uid);
    ref.update({"photoUrl": link});
  }
}
