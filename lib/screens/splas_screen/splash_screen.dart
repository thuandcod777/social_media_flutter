import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_media_flutter/screens/landing_page.dart/lading_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.leftToRight)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'social',
              style: TextStyle(
                  fontFamily: 'Merri',
                  fontWeight: FontWeight.bold,
                  color: constantColors.redColor,
                  fontSize: 30.0),
              children: <TextSpan>[
                TextSpan(
                  text: 'Media',
                  style: TextStyle(
                      fontFamily: 'Merri',
                      color: constantColors.darkColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                )
              ]),
        ),
      ),
    );
  }
}
