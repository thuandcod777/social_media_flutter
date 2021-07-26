import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/post.dart';
import 'package:social_media_flutter/screens/message/message.dart';
import 'package:social_media_flutter/screens/notification/activity.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';
import 'package:social_media_flutter/screens/widget/user_posts_widget.dart';
import 'package:social_media_flutter/utils/firebase.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({Key key}) : super(key: key);

  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  final DateTime timestamp = DateTime.now();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<DocumentSnapshot> post = [];

  bool hasMore = true;
  bool isLoading = false;

  int documentLimit = 10;

  DocumentSnapshot lastDocument;

  ScrollController _scrollController;

  getPosts() async {
    if (!hasMore) {
      print('No New Posts');
    }
    if (isLoading) {
      return CircularProgressIndicator();
    }
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await postRef
          .orderBy('timestamp', descending: false)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await postRef
          .orderBy('timestamp', descending: false)
          .limit(documentLimit)
          .startAfterDocument(lastDocument)
          .get();
    }

    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    post.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    _scrollController?.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        getPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            'Soccial Media',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_) => Activities()));
                    }),
                IconButton(
                    icon: Icon(Icons.chat_bubble),
                    onPressed: () {
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_) => MessageScreen()));
                    }),
              ],
            ),
          ],
        ),
        body: isLoading
            ? circularProgress(context)
            : ListView.builder(
                controller: _scrollController,
                itemCount: post.length,
                itemBuilder: (context, index) {
                  internetChecker(context);
                  PostModel posts = PostModel.fromJson(post[index].data());
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: UserPost(
                      post: posts,
                    ),
                  );
                }));
  }

  internetChecker(context) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == false) {
      showInSnackBar('No Internet Connection', context);
    }
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
