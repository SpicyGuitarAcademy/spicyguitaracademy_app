import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/StudentNotifications.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class NotificationPage extends StatefulWidget {
  @override
  NotificationPageState createState() => new NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  // properties
  dynamic rebuild;
  dynamic page;

  @override
  void initState() {
    super.initState();
  }

  markAsRead(
      context, notification, StudentNotifications studentNotifications) async {
    try {
      loading(context);
      await studentNotifications.markNotificationAsRead(notification['id']);
      // await studentNotifications.getNotifications();
      Navigator.pop(context);
      // setState(() {});
      // rebuild(page);
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  List<Widget> loadNotifications(StudentNotifications studentNotifications) {
    List<Widget> notifications = [];

    studentNotifications.notifications!.forEach((notification) {
      notifications.add(
        Container(
          padding: EdgeInsets.all(5),
          width: screen(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['created_at'],
                style: TextStyle(color: brown),
              ),
              SizedBox(
                height: 5,
              ),
              notification['route'] == ''
                  ? Text(parseHtmlString(notification['message']))
                  : InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, notification['route']);
                      },
                      child: Text(parseHtmlString(notification['message'])),
                    ),
              SizedBox(
                height: 5,
              ),
              notification['status'] == 'unread'
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        onPressed: () async {
                          await markAsRead(
                              context, notification, studentNotifications);
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
    return Consumer<StudentNotifications>(
        builder: (context, studentnotifications, child) {
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
            child: studentnotifications.notifications!.length > 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: loadNotifications(studentnotifications),
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
    });
  }
}
