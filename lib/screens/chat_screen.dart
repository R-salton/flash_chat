import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/utilities/constants.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var loggedInUser;
  bool showSpinner = false;
  String textMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                streamMessages();
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
                StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('messages').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final messages = snapshot.data?.docs;
                        print(messages);
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
                    }),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
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
                          try {
                            _firestore.collection('messages').add({
                              'sender': loggedInUser.email,
                              'text': textMessage
                            });
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

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.message, this.sender});
  final message;
  final sender;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blueGrey,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
            "$message from $sender",
            style: const TextStyle(fontSize: 15.0),
          ),
        ),
      ),
    );
  }
}
