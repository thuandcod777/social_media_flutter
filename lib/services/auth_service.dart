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
    } else {
      return false;
    }
  }

  saveUserToFirestore(
      String name, User user, String email, String country) async {
    await usersRef.doc(user.uid).set({
      'username': name,
      'email': email,
      'time': Timestamp.now(),
      'id': user.uid,
      'country': country,
      'photoUrl': user.photoURL ?? ''
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
}
