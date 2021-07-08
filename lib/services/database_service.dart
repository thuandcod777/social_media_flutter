import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  Future deleteuser() {
    return userCollection.doc(uid).delete();
  }
}
