import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_flutter/utils/firebase.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //final FacebookLogin facebookLogin = FacebookLogin();

  User getCurrentUser() {
    User user = firebaseAuth.currentUser;
    return user;
  }

  Future<bool> logIntoAccount({String email, String password}) async {
    var res = await firebaseAuth.signInWithEmailAndPassword(
        email: '$email', password: '$password');

    if (res.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createAccount(
      {String name,
      User user,
      String email,
      String password,
      String country}) async {
    var res = await firebaseAuth.createUserWithEmailAndPassword(
        email: '$email', password: '$password');

    if (res.user != null) {
      await saveUserToFirestore(name, res.user, email, country);
      return true;
    } else {
      return false;
    }
  }

  saveUserToFirestore(
      String name, User user, String email, String country) async {
    await usersRef.doc(user.uid).set({
      'username': name,
      'email': email,
      'id': user.uid,
      'country': country,
    });
  }

  Future signOutWithEmail() async {
    return await firebaseAuth.signOut();
  }

  /* Future signInWithGoogle() async {
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
  }*/

  String handleFirebaseAuthError(String e) {
    if (e.contains("ERROR_WEAK_PASSWORD")) {
      return "Password is too weak";
    } else if (e.contains("invalid-email")) {
      return "Invalid Email";
    } else if (e.contains("ERROR_EMAIL_ALREADY_IN_USE") ||
        e.contains('email-already-in-use')) {
      return "The email address is already in use by another account.";
    } else if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {
      return "Network error occured!";
    } else if (e.contains("ERROR_USER_NOT_FOUND") ||
        e.contains('firebase_auth/user-not-found')) {
      return "Invalid credentials.";
    } else if (e.contains("ERROR_WRONG_PASSWORD") ||
        e.contains('wrong-password')) {
      return "Invalid credentials.";
    } else if (e.contains('firebase_auth/requires-recent-login')) {
      return 'This operation is sensitive and requires recent authentication.'
          ' Log in again before retrying this request.';
    } else {
      return e;
    }
  }
}
