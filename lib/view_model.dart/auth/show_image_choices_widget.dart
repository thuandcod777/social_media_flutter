import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/view_model.dart/auth/profile_picture.dart';
import 'package:social_media_flutter/view_model.dart/posts/posts_viewmodel.dart';

class ShowImageChoices extends ChangeNotifier {
  showImageChoices(BuildContext context, ProfilePictureViewModel viewModel) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: .4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Select'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          viewModel.pickImage();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.photo,
                              color: Colors.grey,
                            ),
                            Text(
                              'Galerry',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          viewModel.pickImage(camera: true);
                        },
                        child: Row(
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
                  )
                ],
              ),
            ),
          );
        });
  }

  showImagePostChoices(BuildContext context, PostsViewModel viewModel) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: .4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Select'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          viewModel.pickImagePost();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.photo,
                              color: Colors.grey,
                            ),
                            Text(
                              'Galerry',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          viewModel.pickImagePost(camera: true);
                        },
                        child: Row(
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
                  )
                ],
              ),
            ),
          );
        });
  }
}
