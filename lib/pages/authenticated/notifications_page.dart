import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spicyguitaracademy/common.dart';
import 'package:spicyguitaracademy/models.dart';
import 'package:spicyguitaracademy/pages/authenticated/dashboard.dart';
// import 'package:spicyguitaracademy/models.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class NotificationPage extends StatefulWidget {
  @override
  NotificationPageState createState() => new NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  // properties
  // List<dynamic> _notifications = [];

  @override
  void initState() {
    super.initState();
    // _notifications = Student.notifications;
  }

  markAsRead(context, element) async {
    try {
      loading(context);
      await Student.markNotificationAsRead(context, element['id']);
      await Student.getNotifications(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/notification');
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  List<Widget> loadNotifications() {
    List<Widget> notifications = [];

    Student.notifications.forEach((element) {
      notifications.add(
        Container(
          padding: EdgeInsets.all(5),
          width: screen(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                element['created_at'],
                style: TextStyle(color: brown),
              ),
              SizedBox(
                height: 5,
              ),
              element['route'] == ''
                  ? Text(parseHtmlString(element['message']))
                  : InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, element['route']);
                      },
                      child: Text(parseHtmlString(element['message'])),
                    ),
              SizedBox(
                height: 5,
              ),
              element['status'] == 'unread'
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        onPressed: () async {
                          markAsRead(context, element);
                        },
                        child: Text(
                          'Mark as read',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          decoration: BoxDecoration(
            color: grey,
          ),
        ),
      );
      notifications.add(SizedBox(height: 10));
    });

    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        toolbarHeight: 70,
        iconTheme: IconThemeData(color: brown),
        backgroundColor: grey,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
              color: brown,
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Student.notifications.length > 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: loadNotifications(),
                )
              : Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 100),
                    child: Column(
                      children: [
                        Icon(Icons.notifications_off_outlined),
                        SizedBox(
                          height: 10,
                        ),
                        Text('No notifications')
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
