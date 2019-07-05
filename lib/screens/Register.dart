import 'package:flutter/material.dart';
import 'package:squadre/screens/Profile.dart';
import 'package:squadre/utils/Utils.dart';
import 'package:squadre/utils/Firebase.dart' as fbUtils;

class Register extends StatefulWidget {
 // UserModel userModel;

  Register();

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  void initState() {
    super.initState();

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Utils.colorWhite,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image.asset('assets/images/football.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 35),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Enter email",
                          hintStyle: TextStyle(fontSize: 20),
                          labelText: "Email",
                          labelStyle: TextStyle(color: Utils.blackColor),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Utils.greyColor))),
                      controller: emailController,
                      style: TextStyle(fontSize: 23),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Enter name",
                          hintStyle: TextStyle(fontSize: 20),
                          labelText: "Name",
                          labelStyle: TextStyle(color: Utils.blackColor),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Utils.greyColor))),
                      controller: nameController,
                      style: TextStyle(fontSize: 23),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Enter Password",
                          hintStyle: TextStyle(fontSize: 20),
                          labelText: "Password",
                          labelStyle: TextStyle(color: Utils.blackColor),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Utils.greyColor))),
                      controller: passController,
                      style: TextStyle(fontSize: 23),
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                height: 50,
                margin: EdgeInsets.only(top: 30),
                child: RaisedButton(
                    onPressed: () {
                      register(emailController.text, passController.text,
                          nameController.text);
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Utils.colorWhite, fontSize: 20),
                    ),
                    color: Utils.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register(String email, String password, String name) {
    Utils.registerModel.name = name;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Profile()));
    fbUtils.register(email, password, name).then((value) {
      if (value) {
        Utils.showMessage("Successfully Login");
      } else {
        print(Exception);
      }
    }).catchError((error) {
      print(error);
    });
  }
}
