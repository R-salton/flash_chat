import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/utilities/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/utilities/components.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    animation = ColorTween(begin: Colors.blueAccent, end: kBackgroundDarkBlue)
        .animate(controller);

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: SizedBox(
                    height: 100,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                // ignore: deprecated_member_use
                TypewriterAnimatedTextKit(
                  speed: const Duration(milliseconds: 250),
                  text: const [
                    'Flash Chat',
                  ],
                  textStyle: const TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            myButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              backgroundColor: kLightBlue,
              title: "Login",
            ),
            myButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              backgroundColor: kBlueScent,
              title: "Register",
            )
          ],
        ),
      ),
    );
  }
}
