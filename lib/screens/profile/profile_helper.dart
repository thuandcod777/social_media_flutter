import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/landing_page.dart/lading_page.dart';
import 'package:social_media_flutter/services/authentication.dart';

class ProfileHelpers with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 200.0,
          width: 180.0,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  radius: 60.0,
                  backgroundImage:
                      NetworkImage(snapshot.data.data()['userimage']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  snapshot.data.data()['username'],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  snapshot.data.data()['useremail'],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('0', style: TextStyle(color: Colors.white)),
                    Text(
                      'Fllowers',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('1', style: TextStyle(color: Colors.white)),
                    Text('Following', style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    color: constantColors.darkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('3', style: TextStyle(color: Colors.white)),
                    Text('Posts', style: TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 150.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesomeIcons.userAstronaut,
                color: constantColors.yellowColor,
                size: 16.0,
              ),
              Text(
                'Recently Added',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: constantColors.darkColor),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.0)),
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Image.asset(
          'assets/images/empty.png',
          fit: BoxFit.fill,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Log Out Of theSocial?',
              style: TextStyle(
                  color: constantColors.darkColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.redColor,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .signOutWithEmail()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: LandingPage(),
                              type: PageTransitionType.bottomToTop));
                    });
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
