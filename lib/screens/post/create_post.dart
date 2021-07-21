import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/model/user.dart';
import 'package:social_media_flutter/screens/main/main_screen.dart';
import 'package:social_media_flutter/screens/widget/button_widget.dart';
import 'package:social_media_flutter/screens/widget/custom_image.dart';
import 'package:social_media_flutter/utils/firebase.dart';
import 'package:social_media_flutter/view_model.dart/auth/show_image_choices_widget.dart';
import 'package:social_media_flutter/view_model.dart/posts/posts_viewmodel.dart';

class CreatePost extends StatefulWidget {
  static const id = 'create_post';
  const CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    ShowImageChoices showImageChoice = Provider.of<ShowImageChoices>(context);

    PostsViewModel postsViewModel = Provider.of<PostsViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        postsViewModel.resetPost();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Center(
            child: Text('SocialMedia'.toUpperCase()),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Post'.toUpperCase(),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  StreamBuilder(
                      stream: usersRef.doc(currentUserId()).snapshots(),
                      builder:
                          // ignore: missing_return
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Users user = Users.fromJson(snapshot.data.data());
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 50.0,
                                  width: 50.0,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.photoUrl),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            user.username,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          postsViewModel.location == null
                                              ? Container()
                                              : RichText(
                                                  text: TextSpan(
                                                      text: ' - at ',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      children: [
                                                        TextSpan(
                                                            text: postsViewModel
                                                                .location,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ]),
                                                )
                                        ],
                                      ),
                                      Container(
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Album',
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      onChanged: (val) => postsViewModel.setDescription(val),
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        hintText: 'Eg. This is very beautiful place!',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: postsViewModel.imgPostLink != null
                        ? CustomImage(
                            imageUrl: postsViewModel.imgPostLink,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 30,
                            fit: BoxFit.cover,
                          )
                        : postsViewModel.mediaPostUrl == null
                            ? Container()
                            : Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  ClipRRect(
                                    child: Image.file(
                                      postsViewModel.mediaPostUrl,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        postsViewModel.mediaPostUrl = null;
                                      });
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          showImageChoice.showImagePostChoices(
                              context, postsViewModel);
                        },
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.photo_library,
                                color: Colors.green,
                              ),
                              Text('Photo/Video')
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          postsViewModel.getLocation();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            Text('Location')
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ButtonCustom(
                      text: 'Post',
                      function: () async {
                        await postsViewModel.uploadPosts(context);
                        postsViewModel.resetPost();
                        Navigator.pushReplacementNamed(context, MainScreen.id);
                      }),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
