import 'package:flutter/material.dart';

class TextFormBuilder extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onSaved, onChange;

  const TextFormBuilder(
      {this.hintText,
      this.obscureText,
      this.textInputType,
      this.controller,
      this.textInputAction,
      this.onSaved,
      this.onChange,
      key})
      : super(key: key);

  @override
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        onChanged: (val) {
          setState(() {
            widget.onSaved(val);
          });
        },
        onSaved: (val) {
          setState(() {
            widget.onSaved(val);
          });
        },
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: hintStyle(),
            border: border(context),
            focusedBorder: focusBorder(context)),
      ),
    );
  }

  hintStyle() => TextStyle(color: Colors.white);

  border(BuildContext context) => OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      );

  focusBorder(BuildContext context) => OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: BorderSide(color: Colors.white, width: 1.0));
}
