import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/chatroom/chatroom.dart';
import 'package:social_media_flutter/screens/feed/feed.dart';
import 'package:social_media_flutter/screens/home_page/home_helper.dart';
import 'package:social_media_flutter/screens/profile/profile.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();

  final PageController homepageController = PageController();

  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: PageView(
        controller: homepageController,
        children: [Feed(), Chatroom(), Profile()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false)
          .bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
