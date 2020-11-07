import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delgroce/services/AuthUtil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user;
  DocumentSnapshot updateUser;
  File _image;

  Future<void> getUserData() async {
    User userData = await FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
      print(userData.uid);
    });
  }

  Future<void> getUser() async {
    DocumentSnapshot cn = await FirebaseFirestore.instance
        .collection('users')
        .doc('${user.uid}')
        .get();
    return cn;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getUser();
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController contactController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    //For profile pic
    Future getImage() async {
      var image = await ImagePicker().getImage(source: ImageSource.gallery);

      setState(() {
        _image = File(image.path);
        print('Image Path $_image');
      });
    }

    Future uploadPic(imageFile) async {
      String fileName = basename(_image.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask;
      // setState(() {
      //   print("Profile Picture uploaded");
      //   Scaffold.of(context)
      //       .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      // });
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
          );
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }

    Future<void> handleUpdateUserProfile() async {
      String mediaUrl = await uploadPic(_image); // Pass your file variable
      // Create/Update firesotre document
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc('${user.uid}');
      documentReference.update({
        "avatar": mediaUrl,
      });
    }

    // String _userId;
    //
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   _userId = user.uid;
    //   print(_userId);
    //   print(user.uid);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Profile'),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          // Text(
                          //   "Edit Profile",
                          //   style: TextStyle(
                          //       fontSize: 25, fontWeight: FontWeight.w500),
                          // ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Color(0xff476cfb),
                                  child: ClipOval(
                                    child: new SizedBox(
                                        width: 180.0,
                                        height: 180.0,
                                        child: (_image != null)
                                            ? Image.file(
                                                _image,
                                                fit: BoxFit.fill,
                                              )
                                            : (snapshot.data['avatar'] ==
                                                        null ||
                                                    snapshot.data['avatar'] ==
                                                        '')
                                                ? Image.network(
                                                    "https://cdn2.iconfinder.com/data/icons/website-icons/512/User_Avatar-512.png",
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.network(
                                                    snapshot.data['avatar'],
                                                    fit: BoxFit.fill,
                                                  )),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 60.0),
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.camera,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    getImage();
                                    handleUpdateUserProfile();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 35.0),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: "User name",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "${snapshot.data['displayName']}",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter a valid username";
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 35.0),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: "E-mail",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "${snapshot.data['email']}",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 35.0),
                            child: TextFormField(
                              controller: contactController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter a valid Phone Number";
                                }
                                if (value.length != 10) {
                                  return "Please enter a valid Phone Number";
                                }
                                return null;
                              },
                              // initialValue: "${snapshot.data['phoneNumber']}",
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: "Phone Number",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "${snapshot.data['phoneNumber']}",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {},
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Change/Reset Password",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlineButton(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  FirebaseAuth.instance.signOut().then(
                                    (value) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/loginpage',
                                              (Route<dynamic> route) => false);
                                    },
                                  );
                                },
                                child: Text("Logout",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.black)),
                              ),
                              RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    DocumentReference documentReference =
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc('${user.uid}');
                                    documentReference
                                        .update({
                                          // 'uid': user.uid,
                                          'displayName':
                                              usernameController.text,
                                          'phoneNumber': contactController.text,
                                          // 'email': emailController.text,
                                          // 'avatar': _image,
                                        })
                                        .then((result) {})
                                        .catchError((e) {
                                          print(e);
                                        });
                                    // handleUpdateUserProfile();
                                  } else {
                                    print("check errors");
                                  }
                                },
                                color: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                // return UserAccountsDrawerHeader(
                //     currentAccountPicture: new CircleAvatar(
                //       radius: 60.0,
                //       backgroundColor: Colors.transparent,
                //       backgroundImage: NetworkImage(
                //           "https://cdn2.iconfinder.com/data/icons/website-icons/512/User_Avatar-512.png"),
                //     ),
                //     accountName: Text(
                //       "Name: ${snapshot.data['displayName']}",
                //       style: TextStyle(fontSize: 15),
                //     ),
                //     accountEmail: Text(
                //       "Email: ${snapshot.data['email']}",
                //       style: TextStyle(fontSize: 15),
                //     ));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}

Future _showErrorDataDialog(context, String error) async {
  var matDialog = AlertDialog(
    title: new Text("Error"),
    content: new Text(error),
    actions: <Widget>[
      new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  var cupDialog = CupertinoAlertDialog(
    title: new Text("Error"),
    content: new Text(error),
    actions: <Widget>[
      new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  Widget dialog = matDialog;

  if (Platform.isIOS) {
    dialog = cupDialog;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}
