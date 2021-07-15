import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_flutter/screens/login/login.dart';
import 'package:social_media_flutter/screens/widget/text_form_widget.dart';
import 'package:social_media_flutter/view_model.dart/auth/register_view_model.dart';

class Registers extends StatefulWidget {
  const Registers({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Registers> {
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
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
        child: Column(
          children: [
            TextFormBuilder(
                obscureText: false,
                hintText: 'Username',
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                onSaved: (String val) {
                  viewModel.setName(val)(val);
                }),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
                obscureText: false,
                hintText: 'Email',
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSaved: (String val) {
                  viewModel.setEmail(val);
                }),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
                obscureText: false,
                hintText: 'Country',
                textInputAction: TextInputAction.next,
                onSaved: (String val) {
                  viewModel.setCountry(val);
                }),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
                hintText: 'Password',
                obscureText: true,
                textInputAction: TextInputAction.next,
                onSaved: (String val) {
                  viewModel.setPassword(val);
                }),
            SizedBox(
              height: 10.0,
            ),
            TextFormBuilder(
                obscureText: true,
                hintText: 'Confirm Password',
                textInputAction: TextInputAction.done,
                onSaved: (String val) {
                  viewModel.setCPassword(val);
                }),
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
