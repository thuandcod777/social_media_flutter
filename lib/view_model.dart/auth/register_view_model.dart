import 'package:flutter/cupertino.dart';
import 'package:social_media_flutter/screens/login/login.dart';
import 'package:social_media_flutter/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  String username, email, password, country, cPassword;
  bool loading = false;
  AuthService auth = AuthService();

  register(BuildContext context) async {
    loading = true;
    notifyListeners();
    try {
      bool success = await auth.createAccount(
        name: username,
        email: email,
        password: password,
        country: country,
      );
      if (success) {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (_) => Login()));
      }
    } catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setName(val) {
    email = val;
    notifyListeners();
  }

  setPassword(val) {
    email = val;
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
}
