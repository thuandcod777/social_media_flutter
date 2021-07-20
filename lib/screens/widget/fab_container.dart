import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/screens/post/create_post.dart';

class FabContainer extends StatelessWidget {
  final Widget page;
  final IconData icon;
  final bool mini;
  const FabContainer(
      {@required this.page, @required this.icon, this.mini = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(56 / 2))),
      openBuilder: (BuildContext context, VoidCallback _) {
        return page;
      },
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add_to_photos_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            chooseUpload(context);
          },
          mini: mini,
        );
      },
    );
  }

  chooseUpload(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: .5,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 170.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Create Post'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, CreatePost.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          color: Colors.grey,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
