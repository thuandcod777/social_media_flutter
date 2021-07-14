import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/constants/Constantcolors.dart';
import 'package:social_media_flutter/screens/person_profile/person_profile_helper.dart';

class PersonProfile extends StatelessWidget {
  final String userUid;

  PersonProfile({@required this.userUid, Key key}) : super(key: key);

  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<PersonProfileHelper>(context, listen: false)
          .appBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: constantColors.whiteColor,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Provider.of<PersonProfileHelper>(context, listen: false)
                        .headerProfile(context, snapshot, userUid),
                    Provider.of<PersonProfileHelper>(context, listen: false)
                        .footerProfile(context, snapshot)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
