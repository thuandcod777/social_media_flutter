import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/landing_page.dart/landing_utils.dart';
import 'package:social_media_flutter/services/authentication.dart';
import 'package:social_media_flutter/screens/home_page/home_page.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';

class LandingService with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.trashAlt,
                      color: constantColors.redColor,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(documentSnapshot['userimage']),
                  ),
                  subtitle: Text(
                    documentSnapshot['useremail'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor,
                        fontSize: 12.0),
                  ),
                  title: Text(
                    documentSnapshot['username'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter User',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: constantColors.redColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {
                    if (userNameController.text.isNotEmpty) {
                      Provider.of<Authentication>(context, listen: false)
                          .logIntoAccount(
                              userNameController.text, passwordController.text)
                          .whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.bottomToTop));
                      });
                    } else {
                      warningText(context, 'Fill all the data!');
                    }
                  },
                )
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0))),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: true)
                          .userAvatar),
                  backgroundColor: constantColors.redColor,
                  radius: 80.0,
                  child: GestureDetector(onTap: () {
                    Provider.of<LandingUtils>(context, listen: false)
                        .selectAvatarOptionSheet(context);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: userEmailController,
                    decoration: InputDecoration(
                      hintText: 'Enter User',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: constantColors.redColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {
                    if (userNameController.text.isNotEmpty) {
                      Provider.of<Authentication>(context, listen: false)
                          .createAccount(
                              userNameController.text, passwordController.text)
                          .whenComplete(() {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .createUserCollection(context, {
                          'useruid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                          'useremail': userEmailController.text,
                          'username': userNameController.text,
                          'userimage':
                              Provider.of<LandingUtils>(context, listen: false)
                                  .getUserAvatarUrl,
                        });
                      }).whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.bottomToTop));
                      });
                    } else {
                      warningText(context, 'Fill all the data!');
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  warningText(BuildContext context, String waring) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(15.0)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                waring,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  CircleAvatar(
                    radius: 80.0,
                    backgroundColor: constantColors.transperant,
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .userAvatar),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            color: constantColors.blueColor,
                            child: Text(
                              'Reselect',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: constantColors.whiteColor),
                            ),
                            onPressed: () {
                              Provider.of<LandingUtils>(context, listen: false)
                                  .pickUserAvatar(context, ImageSource.gallery);
                            }),
                        MaterialButton(
                            color: constantColors.blueColor,
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .uploadUserAvatar(context)
                                  .whenComplete(() {
                                signInSheet(context);
                                Navigator.pop(context);
                              });
                            })
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0))));
        });
  }
}
