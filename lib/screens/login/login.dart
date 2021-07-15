import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/screens/register/register.dart';
import 'package:social_media_flutter/screens/widget/text_form_widget.dart';
import 'package:social_media_flutter/view_model.dart/auth/login_view_mode.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
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
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => Registers()));
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
          child: Column(
        children: [
          TextFormBuilder(
              hintText: 'Email',
              obscureText: false,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSaved: (String val) {
                viewModel.setEmail(val);
              }),
          SizedBox(
            height: 10.0,
          ),
          TextFormBuilder(
            hintText: 'Password',
            textInputType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
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
