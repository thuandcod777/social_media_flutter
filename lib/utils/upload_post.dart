import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/services/authentication.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController captionController = TextEditingController();

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.whiteColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: constantColors.darkColor,
                        onPressed: () {
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .pickUploadPostImage(
                                  context, ImageSource.gallery);
                        },
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 17.0, color: constantColors.whiteColor),
                        ),
                      ),
                      MaterialButton(
                        color: constantColors.darkColor,
                        onPressed: () {},
                        child: Text('Camera',
                            style: TextStyle(
                                fontSize: 17.0,
                                color: constantColors.whiteColor)),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  showPostIamge(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: constantColors.whiteColor,
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
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                  child: Container(
                    height: 300.0,
                    width: 500.0,
                    child: Image.file(
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.darkColor,
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .pickUploadPostImage(context, ImageSource.gallery);
                      },
                      child: Text(
                        'Reselect',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor),
                      ),
                    ),
                    MaterialButton(
                      color: constantColors.darkColor,
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .uploadPostImageToFirebase()
                            .whenComplete(() {
                          editPostSheet(context);

                          print('Image uploaded!');
                        });
                      },
                      child: Text(
                        'Confirm Image',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            color: constantColors.whiteColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 230.0,
                  width: 330.0,
                  child: Image.file(
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostImage,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  height: 120.0,
                  width: 330.0,
                  child: TextField(
                    maxLines: 5,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    maxLengthEnforced: true,
                    maxLength: 100,
                    controller: captionController,
                    decoration: InputDecoration(
                        hintText: 'Add A Caption...',
                        labelStyle:
                            TextStyle(color: constantColors.whiteColor)),
                  ),
                ),
                MaterialButton(
                  color: constantColors.darkColor,
                  onPressed: () {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostData(context, captionController.text, {
                      'postimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getUploadPostImageUrl,
                      'caption': captionController.text,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getinitUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getinitUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getinitUserEmail,
                    }).whenComplete(() {
                      return FirebaseFirestore.instance
                          .collection('user')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('posts')
                          .add({
                        'postimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getUploadPostImageUrl,
                        'caption': captionController.text,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getinitUserName,
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getinitUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getinitUserEmail,
                      });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Share',
                    style: TextStyle(color: constantColors.whiteColor),
                  ),
                )
              ],
            ),
          );
        });
  }
}
