import 'package:flutter/material.dart';

class TextFormBuilder extends StatefulWidget {
  final String hintText;
  final bool enable;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool obscureText;
  final FocusNode focusNode, nextFocusNode;
  final VoidCallback submitAction;
  final FormFieldValidator<String> validateFunction;

  final void Function(String) onSaved, onChange;

  const TextFormBuilder(
      {this.hintText,
      this.submitAction,
      this.validateFunction,
      this.focusNode,
      this.nextFocusNode,
      this.enable,
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
        enabled: widget.enable,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.black),
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
        validator: widget.validateFunction,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        onFieldSubmitted: (String term) {
          if (widget.nextFocusNode != null) {
            widget.focusNode.unfocus();
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            widget.submitAction();
          }
        },
        decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.white),
            enabledBorder: enableBorder(),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: hintStyle(),
            border: border(context),
            focusedBorder: focusBorder(context)),
      ),
    );
  }

  OutlineInputBorder enableBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    );
  }

  hintStyle() => TextStyle(color: Colors.orange[300]);

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
