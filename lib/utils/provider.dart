import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:social_media_flutter/view_model.dart/auth/login_view_mode.dart';
import 'package:social_media_flutter/view_model.dart/auth/profile_picture.dart';
import 'package:social_media_flutter/view_model.dart/auth/register_view_model.dart';
import 'package:social_media_flutter/view_model.dart/auth/show_image_choices_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => RegisterViewModel()),
  ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ChangeNotifierProvider(create: (_) => ProfilePictureViewModel()),
  ChangeNotifierProvider(create: (_) => ShowImageChoices())
];
