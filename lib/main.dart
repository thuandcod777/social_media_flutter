import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/login/login.dart';
import 'package:social_media_flutter/screens/main/main_screen.dart';
import 'package:social_media_flutter/screens/profile_picture/profile_picture.dart';
import 'package:social_media_flutter/screens/register/register.dart';
import 'package:social_media_flutter/utils/config.dart';
import 'package:social_media_flutter/utils/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
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
        home: Login(),
        routes: {
          MainScreen.id: (context) => MainScreen(),
          Login.id: (context) => Login(),
          Registers.id: (context) => Registers(),
          ProfilePicture.id: (context) => ProfilePicture()
        },
      ),
      providers: providers,
    );
  }
}
