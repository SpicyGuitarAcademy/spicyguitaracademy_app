import 'dart:io';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/utils/upload.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';
// ---------------------------------------------------
// import 'package:'

class UserProfilePage extends StatefulWidget {
  UserProfilePage();

  @override
  UserProfilePageState createState() => new UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  UserProfilePageState();
  File? file;

  @override
  void initState() {
    super.initState();
  }

  void selectImage(Student student) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        file = File(result.files.single.path!);

        loading(context, message: 'Uploading');

        var resp = await upload('/api/student/avatar/update', 'avatar', file,
            method: 'POST',
            headers: {
              'JWToken': Auth.token!,
              'cache-control': 'max-age=0, must-revalidate'
            });
        if (resp['status'] == true) {
          setState(() => student.avatar = resp['data']['path']);
        }
        Navigator.pop(context);
      } else {
        print(result);
      }
    } catch (e) {
      error(context, "Image picker error " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<StudentSubscription>(
          builder: (BuildContext context, studentSubscription, child) {
        return Consumer<StudentStudyStatistics>(
            builder: (BuildContext context, studentStats, child) {
          return Scaffold(
            body: SingleChildScrollView(
                child: Column(children: <Widget>[
              SizedBox(height: 5),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: brown,
                    backgroundImage: NetworkImage('$baseUrl/${student.avatar}',
                        headers: {
                          'cache-control': 'max-age=0, must-revalidate'
                        }),
                  ),
                  IconButton(
                      splashRadius: 30,
                      tooltip: "Update avatar",
                      icon: SvgPicture.asset(
                        "assets/imgs/icons/editprofile.svg",
                        matchTextDirection: true,
                      ),
                      // Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //         color: brown,
                      //         borderRadius: BorderRadius.all(Radius.circular(50))),
                      //     child: Icon(
                      //       Icons.edit,
                      //       color: grey,
                      //     )),
                      onPressed: () {
                        selectImage(student);
                      })
                ],
              ),

              Text("${student.firstname} ${student.lastname}",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18.0,
                      color: darkgrey)),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 1.5, horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: brown),
                  child: Text(
                    "${studentStats.takenCourses} of ${studentStats.allCourses}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Text(
                  "${studentStats.takenLessons} of ${studentStats.allLessons} lessons"),
              SizedBox(height: 50),

              // Button Selections
              Container(
                width: screen(context).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 150.0,
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            onPressed: () {
                              Navigator.pushNamed(context, '/editprofile');
                            },
                            color: Colors.white,
                            textColor: brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/imgs/icons/user_icon_active.svg",
                                  matchTextDirection: true,
                                ),
                                Text("Edit Profile",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 150.0,
                          height: 150.0,
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            onPressed: () {
                              Navigator.pushNamed(context, '/editpassword');
                              //arguments: {'selectedplan': Student.plan}
                            },
                            color: Colors.white,
                            textColor: brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/imgs/icons/lock_icon_active.svg",
                                  height: 23,
                                  matchTextDirection: true,
                                ),
                                Text("Edit Password",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: 15),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 150.0,
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            onPressed: () {
                              Navigator.pushNamed(context, '/choose_category');
                            },
                            color: Colors.white,
                            textColor: brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/imgs/icons/category_icon.svg",
                                  matchTextDirection: true,
                                ),
                                Text("Category",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 150.0,
                          height: 150.0,
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            onPressed: () {
                              Navigator.pushNamed(context, '/choose_plan');
                              //arguments: {'selectedplan': Student.plan}
                            },
                            color: Colors.white,
                            textColor: brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/imgs/icons/subscription_icon.svg",
                                  matchTextDirection: true,
                                ),
                                Text("Subscription",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: 15),
                    Container(
                        width: screen(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 150.0,
                              height: 150.0,
                              child: MaterialButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/invite_friend");
                                },
                                color: Colors.white,
                                textColor: brown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      "assets/imgs/icons/invite_friend_icon.svg",
                                      matchTextDirection: true,
                                    ),
                                    Text("Invite a friend",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 150.0,
                              height: 150.0,
                              child: MaterialButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 25),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/help');
                                },
                                color: Colors.white,
                                textColor: brown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      "assets/imgs/icons/help_circle_icon.svg",
                                      matchTextDirection: true,
                                    ),
                                    Text("Help",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ])),
          );
        });
      });
    });
  }
}
