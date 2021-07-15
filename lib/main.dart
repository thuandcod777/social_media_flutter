import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/login/login.dart';
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
        ),
        providers: providers);
  }
}
