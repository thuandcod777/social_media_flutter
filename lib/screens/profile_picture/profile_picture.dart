import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/screens/widget/custom_image.dart';
import 'package:social_media_flutter/view_model.dart/auth/profile_picture.dart';
import 'package:social_media_flutter/view_model.dart/auth/show_image_choices_widget.dart';

class ProfilePicture extends StatefulWidget {
  static const id = 'profile_screen';
  const ProfilePicture({Key key}) : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    ProfilePictureViewModel viewModel =
        Provider.of<ProfilePictureViewModel>(context);

    ShowImageChoices showImageChoicesViewModel =
        Provider.of<ShowImageChoices>(context);

    return WillPopScope(
      onWillPop: () async {
        viewModel.resetPicture();
        return true;
      },
      child: ModalProgressHUD(
        inAsyncCall: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text('Add Picture Profile'),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 70.0),
              children: [
                InkWell(
                  onTap: () {
                    showImageChoicesViewModel.showImageChoices(
                        context, viewModel);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(170.0)),
                    child: viewModel.imgLink != null
                        ? CustomImage(
                            imageUrl: viewModel.imgLink,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.50,
                            fit: BoxFit.cover,
                          )
                        : viewModel.mediaUrl == null
                            ? Center(
                                child: Text('Upload your profile picture'),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(170.0),
                                child: Image.file(
                                  viewModel.mediaUrl,
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      viewModel.uploadProfilePicture(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Center(child: Text('done'.toUpperCase())))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
