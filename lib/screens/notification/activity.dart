import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/notification.dart';
import 'package:social_media_flutter/screens/widget/activity_stream_wrapper.dart';
import 'package:social_media_flutter/screens/widget/notification_item.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class Activities extends StatefulWidget {
  const Activities({Key key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: Text('Notification'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              deleteAllItem();
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [getActivities()],
      ),
    );
  }

  getActivities() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: ActivityStreamWrapper(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        stream: notificationRef
            .doc(currentUserId())
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, DocumentSnapshot snapshot) {
          ActivityModel activities = ActivityModel.fromJson(snapshot.data());
          return ActivityItems(activity: activities);
        },
      ),
    );
  }

  deleteAllItem() async {
    QuerySnapshot notificationSnap = await notificationRef
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .get();

    notificationSnap.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }
}
