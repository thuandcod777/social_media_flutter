import 'package:flutter/cupertino.dart';
import 'package:social_media_flutter/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  AuthService auth = AuthService();
  String email, password;
  bool loading = false;

  login(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      bool success =
          await auth.logIntoAccount(email: email, password: password);
      print(success);
      if (success) {
        //main
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      print(e);
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
}
