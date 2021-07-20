import 'package:flutter/material.dart';
import 'package:social_media_flutter/screens/message/message.dart';
import 'package:social_media_flutter/screens/profile/profile.dart';
import 'package:social_media_flutter/screens/timeline/time_line.dart';
import 'package:animations/animations.dart';
import 'package:social_media_flutter/screens/widget/fab_container.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main_screen';
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;

  List pages = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'page': TimeLineScreen(),
      'index': 0,
    },
    {
      'title': 'Unsse',
      'icon': Icons.add,
      'page': Text('nes'),
      'index': 1,
    },
    {
      'title': 'Profile',
      'icon': Icons.person,
      'page': ProfileScreen(),
      'index': 2,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: pages[_page]['page'],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 5.0,
              ),
              for (Map item in pages)
                item['index'] == 1
                    ? buildFab()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: IconButton(
                            icon: Icon(
                              item['icon'],
                              color: item['index'] != _page
                                  ? Colors.grey
                                  : Colors.orange,
                              size: 20.0,
                            ),
                            onPressed: () => navigationTapped(item['index'])),
                      ),
              SizedBox(width: 5),
            ],
          ),
        ));
  }

  buildFab() {
    return Container(
      height: 45.0,
      width: 45.0,
      // ignore: missing_required_param
      child: FabContainer(
        icon: Icons.add,
        mini: true,
      ),
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
