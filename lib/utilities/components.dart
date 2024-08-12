import 'package:flutter/material.dart';

class myButton extends StatelessWidget {
  myButton(
      {super.key, required this.onPressed, this.backgroundColor, this.title});

  String? title;
  VoidCallback onPressed;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          // onPressed: () {
          //   //Go to login screen.

          //   // Navigator.pushNamed(context, LoginScreen.id);
          // },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$title',
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.message, this.sender, this.isMe});
  final message;
  final sender;
  final isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0)),
            color: isMe ? (Colors.blueGrey) : Colors.white,
            elevation: 5.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                "$message ",
                style: TextStyle(
                    fontSize: 15.0,
                    color: isMe ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
