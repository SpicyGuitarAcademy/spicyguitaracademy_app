import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Forum.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/StudentSubscription.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class ForumsPage extends StatefulWidget {
  @override
  ForumsPageState createState() => new ForumsPageState();
}

class ForumsPageState extends State<ForumsPage> {
  // properties
  TextEditingController _message = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool canMessage = false;
  List<dynamic> _messages = [];
  String replyId = '0';
  List<Widget> messagesWidget = [
    Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 5.0,
            valueColor: new AlwaysStoppedAnimation<Color>(darkbrown),
          ),
          SizedBox(width: 10),
          Text('Loading messages...')
        ],
      ),
    )
  ];

  List<dynamic> globalKeyList = [];
  int? chatLength;
  double? end;
  dynamic replyViewed;

  @override
  void initState() {
    super.initState();
    initiatePage();
  }

  Future initiatePage() async {
    Student student = context.read<Student>();
    StudentStudyStatistics studentStats =
        context.read<StudentStudyStatistics>();
    StudentSubscription studentSubscription =
        context.read<StudentSubscription>();
    Forum forum = context.read<Forum>();

    if (studentSubscription.subscriptionPlan != "0" &&
        studentStats.studyingCategory! > 0) {
      canMessage = true;
      await loadForumMessages(student, forum, studentStats);
    }
  }

  String forumSubtitle(StudentSubscription studentSubscription,
      StudentStudyStatistics studentStats) {
    String subtitle = "";
    if (studentSubscription.subscriptionPlan == "0") {
      return "Please Subscribe";
    }
    switch (studentStats.studyingCategory) {
      case 0:
        subtitle = "Choose a Category";
        break;
      case 1:
        subtitle = "Beginners Forum";
        break;
      case 2:
        subtitle = "Amateur Forum";
        break;
      case 3:
        subtitle = "Intermediate Forum";
        break;
      case 4:
        subtitle = "Advanced Forum";
        break;
      default:
        subtitle = "Choose a Category";
        break;
    }
    return subtitle;
  }

  sendMessage(
      Student student, Forum forum, StudentStudyStatistics studentStats) async {
    try {
      loading(context);
      await forum.submitMessage(
          studentStats, _message.text, replyId.toString());
      await loadForumMessages(student, forum, studentStats);
      _message.clear();
      replyId = '0';
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  String getRepliedMsg(replyId) {
    if (_messages.isEmpty) return "Replied msg";

    dynamic reply = _messages.firstWhere((msg) {
      return int.parse(msg['id']) == int.parse(replyId);
    });

    if (reply == null) {
      return "Replied msg";
    } else {
      return reply['comment'];
    }
  }

  Widget renderMessage(Student student, comment) {
    String name, avatar, date, who;
    if (student.email == comment['sender']) {
      name = '${student.firstname} ${student.lastname}';
      avatar = '${student.avatar}';
      who = 'me';
    } else {
      if (comment['is_admin'] == '1') {
        name = comment['tutor']['name'];
        avatar = comment['tutor']['avatar'];
        who = 'tutor';
      } else {
        name = comment['student']['name'];
        avatar = comment['student']['avatar'];
        who = 'student';
      }
    }
    date = comment['date_added'];
    GlobalKey key = GlobalKey();
    globalKeyList.add({'id': comment['id'], 'key': key});
    return Dismissible(
        confirmDismiss: (DismissDirection direction) {
          Future<bool>? status;
          this.setState(() {
            replyId = comment['id'];
          });
          return status!;
        },
        direction: DismissDirection.horizontal,
        resizeDuration: null,
        movementDuration: Duration(milliseconds: 10),
        dragStartBehavior: DragStartBehavior.down,
        dismissThresholds: {
          DismissDirection.startToEnd: 0.1,
          DismissDirection.endToStart: 2
        },
        key: key,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: replyViewed == key
                ? [BoxShadow(color: brown, blurRadius: 10.0, spreadRadius: 5.0)]
                : [],
          ),
          margin: EdgeInsets.only(
              left: who == "me" ? screen(context).width * 0.20 : 5,
              right: who != "me" ? screen(context).width * 0.20 : 5,
              top: 5,
              bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              comment['reply_id'] != '0'
                  ? InkWell(
                      onTap: () {
                        scrollToRepliedMsg(comment['reply_id']);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: screen(context).width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: new BoxDecoration(
                              color: Color.fromRGBO(107, 43, 20, 0.2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(getRepliedMsg(comment['reply_id']),
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis), //  comment['reply_id'].toString()
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 10,
                        backgroundColor: brown,
                        backgroundImage: NetworkImage('$baseUrl/$avatar',
                            headers: {
                              'cache-control': 'max-age=0, must-revalidate'
                            })),
                    SizedBox(width: 5),
                    SizedBox(width: 5),
                    comment['is_admin'] == '1'
                        ? Icon(
                            Icons.shield,
                            color: brown,
                            size: 14,
                          )
                        : SizedBox(),
                    Expanded(
                      child: Text("$name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text("$date",
                            maxLines: 1,
                            style: TextStyle(color: brown, fontSize: 12))),
                  ]),
              SizedBox(
                height: 1.0,
              ),
              Text(
                parseHtmlString("${comment['comment']}"),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ));
  }

  loadForumMessages(
      Student student, Forum forum, StudentStudyStatistics studentStats) async {
    try {
      List<dynamic> messages = await forum.getForumMessages(studentStats);
      List<Widget> list = [];

      messages.forEach((message) {
        list.add(renderMessage(student, message));
      });

      this.setState(() {
        messagesWidget = list;
        _messages = messages;
      });

      this.setState(() {
        chatLength = list.length;
      });

      scrollToBottom();
    } catch (e) {
      error(context, stripExceptions(e));
    }
  }

  scrollToBottom() {
    Timer(
        Duration(milliseconds: 300),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
    this.setState(() {
      end = _scrollController.position.maxScrollExtent;
    });
  }

  scrollToRepliedMsg(id) {
    double position = getPosition(id);
    Timer(
        Duration(milliseconds: 300),
        () => _scrollController.animateTo(position,
            duration: Duration(milliseconds: 500), curve: Curves.linear));
  }

  getPosition(String id) {
    int count = 0;
    globalKeyList.firstWhere((gkey) {
      count++;
      if (gkey['id'] == id) {
        this.setState(() {
          replyViewed = gkey['key'];
          print(replyViewed);
        });
        return true;
      } else
        return false;
    });
    double position = (count / chatLength!) * end!;
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<StudentSubscription>(
          builder: (BuildContext context, studentSubscription, child) {
        return Consumer<StudentStudyStatistics>(
            builder: (BuildContext context, studentStats, child) {
          return Consumer<Forum>(builder: (BuildContext context, forum, child) {
            return new Scaffold(
              backgroundColor: grey,
              appBar: AppBar(
                toolbarHeight: 70,
                iconTheme: IconThemeData(color: brown),
                backgroundColor: grey,
                centerTitle: true,
                title: Text(
                  'Forums',
                  style: TextStyle(
                      color: brown,
                      fontSize: 30,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal),
                ),
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(100),
                    child: Container(
                      width: screen(context).width,
                      decoration: new BoxDecoration(
                        color: darkbrown,
                        // borderRadius:
                        //     BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              spreadRadius: 3.0)
                        ],
                      ),
                      child: Text(
                        forumSubtitle(studentSubscription, studentStats),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.normal),
                      ),
                    )),
                elevation: 0,
              ),
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Flexible(
                        child: ListView(
                          addAutomaticKeepAlives: true,
                          semanticChildCount: _messages.length,
                          controller: _scrollController,
                          children: messagesWidget, // Display your list,
                          reverse: false,
                        ),
                      ),
                      canMessage == false
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0)
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    replyId == "0"
                                        ? Container()
                                        : Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                width: screen(context).width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                decoration: new BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      107, 43, 20, 0.2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          getRepliedMsg(
                                                              replyId),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    InkWell(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: darkbrown,
                                                        ),
                                                        onTap: () {
                                                          this.setState(() {
                                                            replyId = '0';
                                                          });
                                                        })
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.0,
                                              ),
                                            ],
                                          ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10, bottom: 10, top: 10),
                                      height: 60,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              loadForumMessages(
                                                  student, forum, studentStats);
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: brown,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Icon(
                                                Icons.replay_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: _message,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              onSubmitted: (value) {
                                                sendMessage(student, forum,
                                                    studentStats);
                                              },
                                              maxLines: 1,
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  fontSize: 20.0, color: brown),
                                              decoration: InputDecoration(
                                                  hintText: "Write message...",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 5),
                                                  border: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1,
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              sendMessage(
                                                  student, forum, studentStats);
                                            },
                                            child: Icon(
                                              Icons.send,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            backgroundColor: brown,
                                            elevation: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
      });
    });
  }
}
