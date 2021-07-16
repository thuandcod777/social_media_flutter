import 'package:flutter/material.dart';
import 'package:social_media_flutter/screens/main/main_screen.dart';
import 'package:social_media_flutter/services/api/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: '_loginScreenkey');

  AuthService auth = AuthService();
  String email, password;

  bool loading = false;
  bool validate = false;

  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();

  login(BuildContext context) async {
    FormState form = formKey.currentState;

    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      loading = true;
      notifyListeners();
      try {
        bool success =
            await auth.logIntoAccount(email: email, password: password);
        print(success);
        if (success) {
          Navigator.pushReplacementNamed(context, MainScreen.id);
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
    }
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
