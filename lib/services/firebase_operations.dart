import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/screens/landing_page.dart/landing_utils.dart';
import 'package:social_media_flutter/services/authentication.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask imageUploadTask;
  String initUserEmail, initUserName, initUserImage;
  String get getinitUserImage => initUserImage;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      print('Image Upload!');
    });

    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();

      print(
          'the user profile avatar => ${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching user data');
      initUserEmail = doc['useremail'];
      initUserName = doc['username'];
      initUserImage = doc['userimage'];

      print(initUserEmail);
      print(initUserName);
      print(initUserImage);
      notifyListeners();
    });
  }
}
