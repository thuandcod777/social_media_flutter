import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/notification.dart';
import 'package:social_media_flutter/model/post.dart';
import 'package:social_media_flutter/screens/widget/activity_notification_detail_view.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';
import 'package:social_media_flutter/utils/firebase.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityItems extends StatefulWidget {
  ActivityModel activity;

  ActivityItems({this.activity});

  @override
  _ActivityItemsState createState() => _ActivityItemsState();
}

class _ActivityItemsState extends State<ActivityItems> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey("${widget.activity}"),
      background: stackBehindDismiss(),
      direction: DismissDirection.endToStart,
      onDismissed: (v) {
        delete();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50.0)),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => ActivityDetailView(
                            activity: widget.activity,
                          )));
                },
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(widget.activity.userDp),
                ),
                title: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                      children: [
                        TextSpan(text: '${widget.activity.username}'),
                        TextSpan(
                            text: buildTextCongiguration(),
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
                subtitle: Text(
                  timeago.format(widget.activity.timestamp.toDate()),
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                trailing: previewConfiguration(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  previewConfiguration() {
    if (widget.activity.type == "like" || widget.activity.type == "comment") {
      return buildPreviewImage();
    } else {
      return Text('');
    }
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.white,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  delete() async {
    notificationRef
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .doc(widget.activity.postId)
          ..get().then((doc) => {
                if (doc.exists) {doc.reference.delete()}
              });
  }

  buildTextCongiguration() {
    if (widget.activity.type == "like") {
      return " liked your post";
    } else if (widget.activity.type == "follow") {
      return " is following you";
    } else if (widget.activity.type == "comment") {
      return " commented for you ${widget.activity.commentData}";
    } else {
      return "Error: Unknown type '${widget.activity.type}'";
    }
  }

  buildPreviewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CachedNetworkImage(
        imageUrl: widget.activity.mediaPostUrl,
        placeholder: (context, url) {
          return circularProgress(context);
        },
        errorWidget: (context, url, error) {
          return Icon(Icons.error);
        },
        height: 40.0,
        fit: BoxFit.cover,
        width: 40.0,
      ),
    );
  }
}
