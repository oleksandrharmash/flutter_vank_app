import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:squadre/utils/Utils.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File image;

  @override
  void initState() {
    getPermission();
  }

  void getPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  Future getImage() async {
    File picture = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 300.0, maxHeight: 500.0);
    setState(() {
      image = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Utils.colorWhite,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                //color: Utils.buttonColor,
                decoration: BoxDecoration(gradient: Utils.gradient),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FractionalTranslation(
                          translation: Offset(0.0, 0.8),
                          child: Text(
                            "M O D I F I C A   P R O F I L E",
                            style: TextStyle(
                                color: Utils.colorWhite, fontSize: 17),
                          )),
                    ),
                    FractionalTranslation(
                      translation: Offset(0, .5),
                      child: FlatButton(
                          onPressed: () {
                            getImage();
                          },
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Utils.purpleColor,
                            //  backgroundImage: Image.file(image);
                            //child: Icon(Icons.add,color: Utils.colorWhite,size: 40,),

                            child: image == null
                                ? Icon(
                                    Icons.add,
                                    color: Utils.colorWhite,
                                    size: 40,
                                  )
                                : CircleAvatar(
                                    radius: 48,
                                    backgroundImage: AssetImage(image.path),
                                  ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  "Nomo Cognome",
                  style: TextStyle(color: Utils.greyColor, fontSize: 30),
                ),
              ),
              Text(
                "Citta",
                style: TextStyle(color: Utils.greyColor),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "inserisci la tua password",
                      labelText: "Password",
                      labelStyle: TextStyle(color: Utils.blackColor)),
                  autofocus: true,
                ),
              ),
              Card(
                elevation: 5,
                margin: EdgeInsets.only(top: 15),
                shape: Border.all(color: Utils.colorHint),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 25, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "la mia squadra del coure e",
                        style: TextStyle(color: Utils.buttonColor),
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Utils.purpleColor,
                              child: Icon(
                                Icons.add,
                                color: Utils.colorWhite,
                                size: 40,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Notification via email"),
                        Switch(
                          value: true,
                          activeColor: Utils.pinkColor,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Push Notification"),
                        Switch(
                          value: true,
                          activeColor: Utils.pinkColor,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.purpleColor,
        onPressed: () {},
        child: Icon(
          Icons.done,
          color: Utils.colorWhite,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
