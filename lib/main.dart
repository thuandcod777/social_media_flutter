import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/login/login.dart';
import 'package:social_media_flutter/screens/main/main_screen.dart';
import 'package:social_media_flutter/screens/notification/activity.dart';
import 'package:social_media_flutter/screens/post/create_post.dart';
import 'package:social_media_flutter/screens/profile/profile.dart';
import 'package:social_media_flutter/screens/profile_picture/profile_picture.dart';
import 'package:social_media_flutter/screens/register/register.dart';
import 'package:social_media_flutter/utils/config.dart';
import 'package:social_media_flutter/view_model.dart/auth/login_view_mode.dart';
import 'package:social_media_flutter/view_model.dart/auth/profile_picture.dart';
import 'package:social_media_flutter/view_model.dart/auth/register_view_model.dart';
import 'package:social_media_flutter/view_model.dart/auth/show_image_choices_widget.dart';
import 'package:social_media_flutter/view_model.dart/message/converation_viewmodel.dart';
import 'package:social_media_flutter/view_model.dart/posts/posts_viewmodel.dart';
import 'package:social_media_flutter/view_model.dart/user/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Merri',
            accentColor: constantColors.blueColor,
            canvasColor: Colors.transparent),
        home: Login(),
        routes: {
          MainScreen.id: (context) => MainScreen(),
          Login.id: (context) => Login(),
          Registers.id: (context) => Registers(),
          ProfilePicture.id: (context) => ProfilePicture(),
          ProfileScreen.id: (context) => ProfileScreen(),
          CreatePost.id: (context) => CreatePost(),
        },
      ),
      providers: [
        ChangeNotifierProvider<PostsViewModel>(create: (_) => PostsViewModel()),
        ChangeNotifierProvider<ShowImageChoices>(
            create: (_) => ShowImageChoices()),
        ChangeNotifierProvider<ProfilePictureViewModel>(
            create: (_) => ProfilePictureViewModel()),
        ChangeNotifierProvider<RegisterViewModel>(
            create: (_) => RegisterViewModel()),
        ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
        ChangeNotifierProvider<ConversationViewModel>(
            create: (_) => ConversationViewModel()),
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
      ],
    );
  }
}
