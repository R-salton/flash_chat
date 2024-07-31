import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/utilities/components.dart';
  
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static String id = "registration";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String massage = "";
  bool showSpin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff164d87),
      body: ModalProgressHUD(
        inAsyncCall: showSpin,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Text(massage.toString()),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                style: const TextStyle(color: Colors.white),
                decoration: kInputDecoration.copyWith(hintText: "Enter email"),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                style: const TextStyle(color: Colors.white),
                decoration:
                    kInputDecoration.copyWith(hintText: "Entert password"),
              ),
              const SizedBox(
                height: 24.0,
              ),
              myButton(
                onPressed: () async{
                  setState(() {
                    showSpin = true;
                  });
                  // TO DO
                  try {
                    final newUSer = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    // ignore: unnecessary_null_comparison
                    if(newUSer != null){
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  setState(() {
                    showSpin = false;
                  });
                  } catch (e) {
                    setState(() {
                      massage = e.toString();
                    });
                    print(e);
                  }
        
                },
                title: "Sign Up",
                backgroundColor: kBackgroundDarkBlue,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: const Text(
                        "login",
                        style: TextStyle(
                            color: Colors.yellow, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
