import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

final Uuid uuid = Uuid();

CollectionReference usersRef = firestore.collection('users');
CollectionReference postRef = firestore.collection('posts');
CollectionReference likesRef = firestore.collection('likes');
CollectionReference commentRef = firestore.collection('comments');
CollectionReference notificationRef = firestore.collection('notification');
CollectionReference followerRef = firestore.collection('follower');
CollectionReference followingRef = firestore.collection('following');
Reference profilePic = storage.ref().child('profilePic');
Reference posts = storage.ref().child('posts');
