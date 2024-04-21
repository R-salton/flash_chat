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
