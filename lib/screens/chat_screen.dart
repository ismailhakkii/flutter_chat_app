// ... diğer importlar
import 'package:chatting_app/main.dart';
import 'package:chatting_app/models/contact.dart';
import 'package:chatting_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class ChatScreen extends StatefulWidget {
  final ContactModel contact;

  ChatScreen({required this.contact});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  late Box<MessageModel> messageBox;

  @override
  void initState() {
    super.initState();
    messageBox = Hive.box<MessageModel>('messages');
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    var appState = Provider.of<AppState>(context, listen: false);
    if (appState.currentUser == null) return;

    var message = MessageModel(
      id: Uuid().v4(),
      contactId: widget.contact.id,
      senderId: appState.currentUser!.id,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );
    messageBox.add(message);
    setState(() {});
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var messages = messageBox.values
        .where((msg) => msg.contactId == widget.contact.id)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var msg = messages[index];
                bool isMe = appState.currentUser != null &&
                    appState.currentUser!.id == msg.senderId;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg.content,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _messageController,
                  decoration:
                      InputDecoration.collapsed(hintText: "Mesajınızı yazın"),
                )),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.blue)
              ],
            ),
          )
        ],
      ),
    );
  }
}
