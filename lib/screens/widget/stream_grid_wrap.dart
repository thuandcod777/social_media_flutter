import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';

typedef ItemBuilder<T> = Widget Function(
    BuildContext conntext, DocumentSnapshot doc);

class StreamGridWrapper extends StatelessWidget {
  final Stream<dynamic> stream;
  final ItemBuilder<DocumentSnapshot> itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const StreamGridWrapper({
    Key key,
    @required this.stream,
    @required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics = const ClampingScrollPhysics(),
    this.padding = const EdgeInsets.only(bottom: 2.0, left: 2.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data.docs.toList();
            return list.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Container(
                      height: 60.0,
                      width: 100.0,
                      child: Center(
                        child: Text('No Post'),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: padding,
                    scrollDirection: scrollDirection,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 3 / 3),
                    itemCount: list.length,
                    shrinkWrap: shrinkWrap,
                    physics: physics,
                    itemBuilder: (BuildContext context, int index) {
                      return itemBuilder(context, list[index]);
                    });
          } else {
            return circularProgress(context);
          }
        });
  }
}
