import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/screens/widget/circular_progress.dart';

typedef ItemBuilder<T> = Widget Function(
    BuildContext context, DocumentSnapshot doc);

class CommentStreamWrapper extends StatelessWidget {
  final Stream<dynamic> stream;
  final ItemBuilder<DocumentSnapshot> itemBuilder;
  final Axis scrollDirection;
  final BorderRadius borderRadius;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;
  const CommentStreamWrapper(
      {@required this.stream,
      @required this.itemBuilder,
      this.borderRadius,
      this.scrollDirection = Axis.vertical,
      this.shrinkWrap = false,
      this.physics = const NeverScrollableScrollPhysics(),
      this.padding = const EdgeInsets.only(bottom: 2.0, left: 2.0),
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var list = snapshot.data.docs.toList();
              return list.length == 0
                  ? Container(
                      child: Center(
                      child: Text('No Comment'),
                    ))
                  : Container(
                      color: Colors.white,
                      child: ListView.builder(
                          reverse: true,
                          padding: padding,
                          scrollDirection: scrollDirection,
                          itemCount: list.length,
                          shrinkWrap: shrinkWrap,
                          physics: physics,
                          itemBuilder: (BuildContext context, int index) {
                            return itemBuilder(context, list[index]);
                          }),
                    );
            } else {
              return circularProgress(context);
            }
          }),
    );
  }
}
