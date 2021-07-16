import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/screens/login/login.dart';
import 'package:social_media_flutter/screens/widget/text_form_widget.dart';
import 'package:social_media_flutter/utils/validation.dart';
import 'package:social_media_flutter/view_model.dart/auth/register_view_model.dart';

class Registers extends StatefulWidget {
  static const id = 'register_screen';

  const Registers({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Registers> {
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      key: viewModel.scaffoldKey,
      backgroundColor: Colors.orange,
      body: ListView(
        children: [
          Center(
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white, fontSize: 50.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  'Social Media ',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                Text(
                  'Create a new account and connect with social',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          buildTextForm(context, viewModel),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => Login()));
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  buildTextForm(BuildContext context, RegisterViewModel viewModel) => Form(
        key: viewModel.formKey,
        child: Column(
          children: [
            TextFormBuilder(
              enable: !viewModel.loading,
              obscureText: false,
              hintText: 'Username',
              validateFunction: Validation.validateName,
              textInputAction: TextInputAction.next,
              onSaved: (String val) {
                viewModel.setName(val);
              },
              focusNode: viewModel.usernameFN,
              nextFocusNode: viewModel.emailFN,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
              enable: !viewModel.loading,
              obscureText: false,
              hintText: 'Email',
              textInputAction: TextInputAction.next,
              onSaved: (String val) {
                viewModel.setEmail(val);
              },
              validateFunction: Validation.validateEmail,
              focusNode: viewModel.emailFN,
              nextFocusNode: viewModel.countryFN,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
              enable: !viewModel.loading,
              obscureText: false,
              hintText: 'Country',
              textInputAction: TextInputAction.next,
              onSaved: (String val) {
                viewModel.setCountry(val);
              },
              focusNode: viewModel.countryFN,
              nextFocusNode: viewModel.passFN,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
              enable: !viewModel.loading,
              hintText: 'Password',
              obscureText: true,
              validateFunction: Validation.validatePassword,
              textInputAction: TextInputAction.next,
              onSaved: (String val) {
                viewModel.setPassword(val);
              },
              focusNode: viewModel.passFN,
              nextFocusNode: viewModel.cPassFN,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
              enable: !viewModel.loading,
              obscureText: true,
              hintText: 'Confirm Password',
              textInputAction: TextInputAction.done,
              submitAction: () => viewModel.register(context),
              onSaved: (String val) {
                viewModel.setCPassword(val);
              },
              focusNode: viewModel.cPassFN,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 40.0,
              width: 180.0,
              child: ElevatedButton(
                  onPressed: () {
                    viewModel.register(context);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange[400]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)))),
                  child: Text('Sign Up'.toUpperCase())),
            )
          ],
        ),
      );
}
