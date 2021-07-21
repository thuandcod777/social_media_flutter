import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final BorderRadius borderRadius;
  final bool elevated;
  const CustomCard(
      {@required this.child,
      this.onTap,
      this.borderRadius,
      this.elevated = true,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: elevated
          ? BoxDecoration(borderRadius: borderRadius, color: Colors.white)
          : BoxDecoration(borderRadius: borderRadius, color: Colors.white),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
