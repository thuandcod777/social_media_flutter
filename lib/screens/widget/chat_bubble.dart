import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_flutter/model/enum/message_type.dart';
import 'package:social_media_flutter/screens/widget/text_time.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatefulWidget {
  final String message;
  final MessageType type;
  final Timestamp time;
  final bool isMe;

  const ChatBubble(
      {@required this.message,
      @required this.time,
      @required this.isMe,
      @required this.type,
      Key key})
      : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  Color chatBubbleColor() {
    if (widget.isMe) {
      return Colors.grey[300];
    } else {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.grey[800];
      } else {
        return Colors.grey[200];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = widget.isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(5.0),
          decoration:
              BoxDecoration(color: chatBubbleColor(), borderRadius: radius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${widget.message}',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        TextTime(
          child: Text(
            timeago.format(widget.time.toDate()),
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }
}
