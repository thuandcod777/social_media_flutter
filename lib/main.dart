import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/feed/feed_helper.dart';
import 'package:social_media_flutter/screens/home_page/home_helper.dart';
import 'package:social_media_flutter/screens/landing_page.dart/landing_utils.dart';
import 'package:social_media_flutter/screens/person_profile/person_profile_helper.dart';
import 'package:social_media_flutter/screens/profile/profile_helper.dart';
import 'package:social_media_flutter/services/authentication.dart';
import 'package:social_media_flutter/screens/landing_page.dart/landing_helper.dart';
import 'package:social_media_flutter/screens/landing_page.dart/landing_service.dart';
import 'package:social_media_flutter/screens/splas_screen/splash_screen.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';
import 'package:social_media_flutter/utils/post_functions.dart';
import 'package:social_media_flutter/utils/upload_post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        home: SplashScreen(),
      ),
      providers: [
        ChangeNotifierProvider(
          create: (_) => LandingHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingService(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingUtils(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseOperations(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => FeedHelper(),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadPost(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostFunctions(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomepageHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => PersonProfileHelper(),
        ),
        ChangeNotifierProvider(create: (_) => Authentication())
      ],
    );
  }
}
