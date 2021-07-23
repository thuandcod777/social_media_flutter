import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/notification.dart';
import 'package:social_media_flutter/model/post.dart';
import 'package:social_media_flutter/model/user.dart';
import 'package:social_media_flutter/screens/profile/profile.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';
import 'package:social_media_flutter/utils/firebase.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityDetailView extends StatefulWidget {
  ActivityModel activity;
  PostModel post;
  ActivityDetailView({this.post, this.activity});

  @override
  _ActivityDetailViewState createState() => _ActivityDetailViewState();
}

class _ActivityDetailViewState extends State<ActivityDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.keyboard_backspace),
        ),
        title: Text(
          'Comments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          buildImage(context),
          ListTile(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ProfileScreen(
                      profileId: widget.activity.userId,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.activity.userDp),
              ),
            ),
            title: Text(widget.activity.username),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 17.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(timeago.format(widget.activity.timestamp.toDate())),
                  ],
                ),
                Text(widget.activity.commentData ?? "")
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: widget.activity.mediaPostUrl,
          placeholder: (context, url) {
            return circularProgress(context);
          },
          errorWidget: (context, url, error) {
            return Icon(Icons.error);
          },
          height: 400.0,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
