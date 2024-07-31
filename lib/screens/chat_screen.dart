import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/utilities/components.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/utilities/constants.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageController = TextEditingController();
  var loggedInUser;
  bool showSpinner = false;
  String textMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getMessage();
  }

  void getUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void streamMessages() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  void getMessage() async {
    // final messages = await _firestore.collection('message').get();

    // for (var message in messages.docs) {
    //   print(message);
    // }
    await for (var snapshot in _firestore.collection('message').snapshots()) {
      for (var messages in snapshot.docs) {
        print(messages.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // setState(() {
                //   showSpinner = true;
                // });
                // //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
                // setState(() {
                //   showSpinner = false;
                // });
                // streamMessages();
                getMessage();
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: kBlueScent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Container(
            color: kBackgroundDarkBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const MessageStream(),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            //Do something with the user input.
                            textMessage = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //Implement send functionality.
                          messageController.clear();
                          try {
                            _firestore.collection('messages').add({
                              'sender': loggedInUser.email,
                              'text': textMessage
                            });
                            textMessage = '';
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data?.docs;

            List<MessageBubble> messageBubbles = [];
            for (var message in messages!) {
              final messageText = message['text'];
              final messageSender = message["sender"];
              final messageBubble = MessageBubble(
                sender: messageSender,
                message: messageText,
              );

              messageBubbles.add(messageBubble);
            }

            return Expanded(
              child: ListView(
                children: messageBubbles,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: kBackgroundDarkBlue,
              ),
            );
          }
        });
  }
}
