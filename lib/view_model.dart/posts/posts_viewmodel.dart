import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_flutter/model/post.dart';
import 'package:social_media_flutter/services/post_service.dart';
import 'package:social_media_flutter/utils/firebase.dart';

class PostsViewModel extends ChangeNotifier {
  PostService postService = PostService();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;
  String location;
  final picker = ImagePicker();
  String description;
  String userNamePost;
  String email;
  String ownerId;
  String userId;
  String id;
  File mediaPostUrl;
  String imgPostLink;
  Position position;
  Placemark placemark;
  String nameLocation;

  //TextEditingController locationTEC = TextEditingController();

  setPost(PostModel post) {
    if (post = null) {
      description = post.description;
      imgPostLink = post.mediaPostUrl;
      location = post.location;
      notifyListeners();
    }
  }

  setUsername(String val) {
    userNamePost = val;
    notifyListeners();
  }

  setDescription(String val) {
    description = val;
    notifyListeners();
  }

  setLocation(String val) {
    location = val;
    notifyListeners();
  }

  pickImagePost({bool camera = false, BuildContext context}) async {
    loading = true;
    notifyListeners();

    try {
      PickedFile pickedFile = await picker.getImage(
          source: camera ? ImageSource.camera : ImageSource.gallery);

      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      mediaPostUrl = File(croppedFile.path);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancelled', context);
    }
  }

  getLocation() async {
    loading = true;
    notifyListeners();
    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission permission = await Geolocator.requestPermission();
      print(permission);
      await getLocation();
    } else {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      placemark = placemarks[0];
      location = "${placemarks[0].locality},${placemarks[0].country}";
      //locationTEC.text = location;
      print(location);
    }
    loading = false;
    notifyListeners();
  }

  uploadPosts(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      await postService.uploadPost(mediaPostUrl, location, description);
      loading = false;
      resetPost();
      notifyListeners();
    } catch (e) {
      loading = false;
      resetPost();
      showInSnackBar('Uploaded successfully!', context);
      notifyListeners();
    }
  }

  resetPost() {
    mediaPostUrl = null;
    description = null;
    location = null;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
