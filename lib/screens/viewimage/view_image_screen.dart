import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/post.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class ViewImageScreen extends StatefulWidget {
  final PostModel post;
  const ViewImageScreen({this.post, Key key}) : super(key: key);

  @override
  _ViewImageScreenState createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  currentUserId() {
    firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: buildImage(context),
      ),
    );
  }

  buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ClipRRect(
        child: CachedNetworkImage(
          imageUrl: widget.post.mediaPostUrl,
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
