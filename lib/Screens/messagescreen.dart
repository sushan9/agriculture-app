import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartagro/Components/messageBubble.dart';
import '../constants.dart';
final _firestore = Firestore.instance;
bool test = false;
class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String message;
  void updatemessage() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var messagedata in snapshot.documents) {
        print(messagedata.data);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final MessageTextController= TextEditingController();
    return Scaffold(
          body: Container( child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
      messageStream(),
      Container(
       // padding:EdgeInsets.fromLTRB(left, top, right, bottom)
        padding: EdgeInsets.only(left:30.0,bottom:30.0),
        //decoration: kMessageContainerDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            
            Expanded(
              
              
              child: TextField(
              
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:InputDecoration(
                  hintText: 'Write your message here ....',
                  hintStyle: TextStyle(color:Colors.grey.shade400),
                  filled: true,
                  contentPadding: EdgeInsets.all(15.0),
                    border:OutlineInputBorder(borderRadius:BorderRadius.circular(40.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.grey.shade100),
                      ),
                ),
              
                controller: MessageTextController,
                onChanged: (value) {
                  message = value;
                },
                // decoration: kMessageTextFieldDecoration
              ),
              
            ),
            
            FlatButton(
                onPressed :() {
                  test = true;
                    MessageTextController.clear();
                  _firestore.collection('messages').add({
                    
                    'text': message,
                    'date': DateTime.now().toIso8601String().toString(),
                    'isme': true,
                    
                      

                  });
                },
                child: 
                Icon(Icons.send,color: Colors.lightBlueAccent,),
                // Text(
                //   'Send',
                //   style: kSendButtonTextStyle,
                // ),
              ),
          ],
        ),
      ),
          ],
        ),),
    );
  }
}
  class messageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Expanded(
  child: StreamBuilder<QuerySnapshot>(
  stream: _firestore.collection('messages').orderBy('date').snapshots(),
  builder: (context, snapshot) {
  if (!snapshot.hasData) {
  return Container(alignment:Alignment.center,child: CircularProgressIndicator(strokeWidth: 4,));
  }
  final messages = snapshot.data.documents.reversed;
  List<MessageBubble> messageWidget = [];
  for (var message in messages) {
  Padding:EdgeInsets.all(0.0);
  final messagetext = message.data['text'];
  final testo = message.data['isme'];
  final messagewid = MessageBubble(text: messagetext, isMe: testo,);
  messageWidget.add(messagewid);
  }
  return Container(child: ListView(reverse: true,
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  children: messageWidget));
  },
  ),
  );
  }
}
