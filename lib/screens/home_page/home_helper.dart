import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';

class HomepageHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  String url = '';

  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Color(0xff040307),
      items: [
        CustomNavigationBarItem(
          icon: Icon(
            EvaIcons.home,
            color: Colors.white,
          ),
        ),
        CustomNavigationBarItem(
            icon: Icon(Icons.message_rounded, color: Colors.white)),
        CustomNavigationBarItem(
          icon: CircleAvatar(
              radius: 35.0,
              backgroundColor: constantColors.blueGreyColor,
              backgroundImage: Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getinitUserImage !=
                      null
                  ? NetworkImage(
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getinitUserImage)
                  : null),
        )
      ],
    );
  }
}
