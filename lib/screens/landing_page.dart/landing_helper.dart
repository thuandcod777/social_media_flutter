import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/services/authentication.dart';
import 'package:social_media_flutter/screens/home_page/home_page.dart';
import 'package:social_media_flutter/screens/landing_page.dart/landing_service.dart';

class LandingHelpers with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/logo.png'))),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: 450.0,
      left: 10.0,
      child: Container(
        constraints: BoxConstraints(maxWidth: 170.0),
        child: RichText(
          text: TextSpan(
              text: 'wellcome',
              style: TextStyle(
                  fontFamily: 'Merri',
                  color: constantColors.blueGreyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 27.0),
              children: <TextSpan>[
                TextSpan(
                  text: ' Social',
                  style: TextStyle(
                      fontFamily: 'Merri',
                      color: constantColors.redColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 27.0),
                ),
                TextSpan(
                  text: ' Media',
                  style: TextStyle(
                      fontFamily: 'Merri',
                      color: constantColors.blueGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 27.0),
                ),
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
        top: 580.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  print('Signing with email');
                  emailAuthSheet(context);
                },
                child: Container(
                  child: Icon(
                    EvaIcons.emailOutline,
                    color: constantColors.lightBlueColor,
                  ),
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Signing with google');
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.leftToRight));
                  });
                },
                child: Container(
                  child: Icon(
                    EvaIcons.google,
                    color: constantColors.blueColor,
                  ),
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              GestureDetector(
                child: Container(
                  child: Icon(
                    EvaIcons.facebook,
                    color: constantColors.redColor,
                  ),
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              )
            ],
          ),
        ));
  }

  Widget privacyPolicyText(BuildContext context) {
    return Positioned(
        top: 640.0,
        left: 20.0,
        right: 20.0,
        child: Container(
          child: Column(
            children: [
              Text(
                "By continuing you agree theSocial's Term off",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
              ),
              Text(
                "Services & Privacy Policy",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
              )
            ],
          ),
        ));
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4.0,
                  ),
                ),
                Provider.of<LandingService>(context, listen: false)
                    .passwordLessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Provider.of<LandingService>(context, listen: false)
                            .logInSheet(context);
                      },
                      color: constantColors.blueColor,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Provider.of<LandingService>(context, listen: false)
                            .signInSheet(context);
                      },
                      color: constantColors.redColor,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))),
          );
        });
  }
}
