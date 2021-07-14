import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_flutter/services/database_service.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //final FacebookLogin facebookLogin = FacebookLogin();

  String userUid;
  String get getUserUid => userUid;

  Future logIntoAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    User user = userCredential.user;
    userUid = user.uid;
    print(userUid);
    notifyListeners();
  }

  Future createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User user = userCredential.user;
    userUid = user.uid;
    print('created account Uid=>$userUid');
    notifyListeners();
  }

  Future signOutWithEmail() async {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User user = userCredential.user;
    assert(user.uid != null);

    userUid = user.uid;
    print('Google User Uid==>$userUid');
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }

  //the way another
  /*Future deleteUser(String email, String password) async {
    try {
      User user = await firebaseAuth.currentUser;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      UserCredential result =
          await user.reauthenticateWithCredential(credential);
      await DatabaseService(uid: result.user.uid).deleteuser();
      await result.user.delete();
      return true;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }*/

  /* Future signInFacebook() async {
    try {
      final FacebookLoginResult result = await facebookLogin.logIn(
          permissions: [
            FacebookPermission.publicProfile,
            FacebookPermission.email
          ]);

      switch (result.status) {
        case FacebookLoginStatus.success:
          String token = result.accessToken.token;
          final AuthCredential credential =
              FacebookAuthProvider.credential(token);

          await firebaseAuth.signInWithCredential(credential);

          break;
        case FacebookLoginStatus.cancel:
          break;
        case FacebookLoginStatus.error:
          print(result.error);
          break;
      }
      return true;
    } catch (error) {
      return false;
    }
  }*/
}
