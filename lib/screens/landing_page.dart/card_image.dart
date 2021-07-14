import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/screens/landing_page.dart/landing_utils.dart';
import 'package:social_media_flutter/services/firebase_operations.dart';

class CardImage extends StatefulWidget {
  const CardImage({Key key}) : super(key: key);

  @override
  _CardImageState createState() => _CardImageState();
}

class _CardImageState extends State<CardImage> {
  File _image;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<LandingUtils>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            setState(() {
              _image = image;
            });
            if (image != null) {
              _authData.isPicAvail = true;
            }
            print(_image.path);
          });
          Provider.of<FirebaseOperations>(context, listen: false)
              .uploadUserAvatar(context);
        },
        child: SizedBox(
          height: 150.0,
          width: 150.0,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: _image == null
                  ? Center(
                      child: Text('Add Shop Image',
                          style: TextStyle(color: Colors.grey)))
                  : Image.file(_image, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
