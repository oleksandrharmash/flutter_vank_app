import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstant;
import 'package:squadre/utils/Firebase.dart' as fbUtils;
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/widgets/ChatMessages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';


class ChatPage extends StatefulWidget {
  Map data;

  ChatPage(this.data);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String question;
  bool isUploading = false;
  Map<dynamic, dynamic> snapshotValues;

  TextEditingController replyController;

  @override
  void initState() {
    super.initState();
    question = "";

    print(widget.data);
    replyController = TextEditingController();
    getChatReplies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.colorAppBar,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Utils.blueColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940")
              ),
            ),
            Text(
              "Participent Name",
              style: TextStyle(fontSize: 16, color: Utils.blackColor),
            )
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                child: isUploading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        children: _buildReply(),
                      )),
            Utils.registerModel.isAdmin
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: BottomAppBar(
                      color: Utils.colorAppBar,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 5),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                pickVideo();
                              },
                              icon: Icon(
                                Icons.add,
                                color: Utils.blueColor,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Utils.colorWhite),
                              width: MediaQuery.of(context).size.width - 105,
                              child: TextField(
                                controller: replyController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                fbUtils.addPostReply(
                                    replyController.text,
                                    Utils.registerModel.isAdmin,
                                    Utils.registerModel.uuid,
                                    widget.data[AppConstant.POST_ID],
                                    false);

                                replyController.text = '';
                                getChatReplies();
                              },
                              icon: Icon(
                                Utils.registerModel.isAdmin
                                    ? Icons.send
                                    : Icons.send,
                                color: Utils.blueColor,
                              ),
                            ),
//                      IconButton(
//                        onPressed: () {},
//                        icon: Icon(
//                          Icons.settings_voice,
//                          color: Utils.blueColor,
//                        ),
//                      ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void getChatReplies() {
    print('getChatReplies');
    fbUtils.getReplies(widget.data[AppConstant.POST_ID]).then((db) {
      db.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        print('getChatReplies $values');

        if (values != null) {
          question = values['message'].toString();

          setState(() {
            snapshotValues = values;
          });
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  void pickVideo() async {
    String filePath;
    filePath = await FilePicker.getFilePath(type: FileType.VIDEO);
    await _uploadFile(filePath);
  }

  _uploadFile(String filePath) async {
    setState(() {
      isUploading = true;
    });
    var name = basename(filePath);
    var index = name.lastIndexOf('.');
    var ext = name.substring(index);
    final String uuid = Uuid().v1();
    final Directory systemTempDir = Directory.systemTemp;
    final File file = await File(filePath).create();

    final StorageReference ref =
        FirebaseStorage.instance.ref().child('media').child('vid_$uuid$ext');
    final StorageUploadTask uploadTask = ref.putFile(file);
    uploadTask.events.listen((onData) async {
      final complete = uploadTask.isComplete;
      if (complete) {
        setState(() {
          isUploading = false;
        });
        String url = await _getUrl(uploadTask);
        print('upload video url $url');
        fbUtils.addPostReply(url, Utils.registerModel.isAdmin,
            Utils.registerModel.uuid, widget.data[AppConstant.POST_ID], true);
        getChatReplies();
      }
      return null;
    }, onError: (err) {
      setState(() {
        isUploading = false;
      });
      //print(err);
      return null;
    });
  }

  _getUrl(StorageUploadTask task) async {
    return await task.lastSnapshot.ref.getDownloadURL();
  }

  List<Widget> _buildReply() {
    List<Widget> list = [];
    //values['message'].toString()
    //list.add(Text(question.toString()));

    if (snapshotValues != null) {
      list.add(Bubble(
        message: snapshotValues['message'].toString(),
        time: Utils.readTimestamp(snapshotValues['time']),
        delivered: true,
        isMe: true,
        isVideo: false,
      ));
      LinkedHashMap replies = snapshotValues['replies'];
      if (replies != null) {
        replies.forEach((k, v) {
          list.add(Bubble(
            message: v['reply'],
            time: Utils.readTimestamp(v['time']),
            delivered: true,
            isMe: false,
            isVideo: v['isVideo'],
          ));
        });
      }
    }
    return list;
    //Bubble(snapshotValues['reply'])
  }
}
