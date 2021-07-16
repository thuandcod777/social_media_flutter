import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/screens/login/login.dart';
import 'package:social_media_flutter/screens/profile_picture/profile_picture.dart';
import 'package:social_media_flutter/services/api/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  String username, email, password, country, cPassword;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: '_registerScreenkey');

  bool loading = false;
  bool validate = false;

  AuthService auth = AuthService();

  FocusNode usernameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode countryFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode cPassFN = FocusNode();

  register(BuildContext context) async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
    } else {
      if (password == cPassword) {
        loading = true;
        notifyListeners();
        try {
          bool success = await auth.createAccount(
            name: username,
            email: email,
            password: password,
            country: country,
          );
          print(success);
          if (success) {
            Navigator.pushReplacementNamed(context, ProfilePicture.id);
          }
        } catch (e) {
          loading = false;
          notifyListeners();
          print(e);
          showInSnackBar(
              '${auth.handleFirebaseAuthError(e.toString())}', context);
        }
        loading = false;
        notifyListeners();
      } else {
        showInSnackBar('The passwords does not match', context);
      }
    }
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setName(val) {
    username = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  setCPassword(val) {
    cPassword = val;
    notifyListeners();
  }

  setCountry(val) {
    country = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
