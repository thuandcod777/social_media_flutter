import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/screens/register/register.dart';
import 'package:social_media_flutter/screens/widget/text_form_widget.dart';
import 'package:social_media_flutter/utils/validation.dart';
import 'package:social_media_flutter/view_model.dart/auth/login_view_mode.dart';

class Login extends StatefulWidget {
  static const id = 'login_screen';
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      key: viewModel.scaffoldKey,
      backgroundColor: Colors.orange,
      body: ListView(
        children: [
          Container(
              height: 200.0,
              color: Colors.orange,
              child: Image.asset('assets/images/logo.png')),
          Center(
            child: Text(
              'Sign In',
              style: TextStyle(fontSize: 50.0, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          buildForm(context, viewModel),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, Registers.id);
                },
                child: Text(
                  'Sign Up',
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

  buildForm(BuildContext context, LoginViewModel viewModel) => Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          TextFormBuilder(
            enable: !viewModel.loading,
            hintText: 'Email',
            obscureText: false,
            validateFunction: Validation.validateEmail,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.passFN,
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormBuilder(
            enable: !viewModel.loading,
            hintText: 'Password',
            textInputType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            submitAction: () => viewModel.login(context),
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Forgor Password?',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 40.0,
            width: 180.0,
            child: ElevatedButton(
                onPressed: () {
                  viewModel.login(context);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange[400]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)))),
                child: Text('Sign In'.toUpperCase())),
          )
        ],
      ));
}
