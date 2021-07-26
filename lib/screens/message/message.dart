import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: buildSearch(),
      ),
    );
  }

  buildSearch() => Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Center(
            child: TextFormField(
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          textCapitalization: TextCapitalization.sentences,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          inputFormatters: [
            LengthLimitingTextInputFormatter(20),
          ],
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                searchController.clear();
              },
              child: Icon(Icons.delete, size: 12.0, color: Colors.black),
            ),
            contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
        )),
      ));
}
