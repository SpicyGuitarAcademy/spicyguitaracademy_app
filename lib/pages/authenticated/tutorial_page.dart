import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/Lessons.dart';
import 'package:spicyguitaracademy_app/providers/Student.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/providers/Tutorial.dart';
import 'package:spicyguitaracademy_app/services/cache_manager.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:spicyguitaracademy_app/widgets/custom_pdf_viewer.dart';
import 'package:spicyguitaracademy_app/widgets/custom_video_player.dart';
import 'package:spicyguitaracademy_app/widgets/custom_audio_player.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class TutorialPage extends StatefulWidget {
  TutorialPage();

  @override
  TutorialPageState createState() => new TutorialPageState();
}

enum Screen { video, audio, practice, tablature, none }

class TutorialPageState extends State<TutorialPage> {
  Screen _displayscreen = Screen.none;
  bool _showNote = false;
  bool _showComment = false;
  TextEditingController _comment = new TextEditingController();
  List<Widget> _commentWidgets = [];
  // PDFDocument? _pdfDocument;

  @override
  void initState() {
    super.initState();
    initiateTutorial();
  }

  Future initiateTutorial() async {
    Student student = context.read<Student>();
    Courses courses = context.read<Courses>();
    Lessons lessons = context.read<Lessons>();
    Tutorial tutorial = context.read<Tutorial>();

    if (tutorial.tutorialLessons?.length == 0) {
      print('No lessons');
    }

    // this condition was put in place to restrict students from accessing
    // courses after they've been told to await their assignment review
    if (lessons.source == LessonSource.normal &&
        (tutorial.currentTutorial == null ||
            courses.currentCourse?.status == false ||
            tutorial.tutorialLessons?.length == 0)) {
      Navigator.pop(context);
    }

    if (tutorial.currentTutorial?.video != null) {
      _displayscreen = Screen.video;
    } else if (tutorial.currentTutorial?.audio != null) {
      _displayscreen = Screen.audio;
    } else if (tutorial.currentTutorial?.tablature != null) {
      _displayscreen = Screen.tablature;
    } else if (tutorial.currentTutorial?.practice != null) {
      _displayscreen = Screen.practice;
    }

    // await loadPdf(tutorial);
    await loadUserCommentsOnThisLesson(student, tutorial);
  }

  _submitComment(Student student, Tutorial tutorial) async {
    try {
      loading(context);
      await tutorial.submitComment(context, _comment.text,
          tutorial.currentTutorial!.id, tutorial.currentTutorial!.tutor);
      _comment.clear();
      Navigator.pop(context);
      await loadUserCommentsOnThisLesson(student, tutorial);
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  loadUserCommentsOnThisLesson(Student student, Tutorial tutorial) async {
    try {
      List<dynamic> comments = await tutorial.getTutorialComments(context);

      List<Widget> commentsWidgets = [];
      comments.forEach((comment) {
        String name, avatar, date;
        // who;
        if (student.email == comment['sender']) {
          name = '${student.firstname} ${student.lastname}';
          avatar = '${student.avatar}';
          // who = 'me';
        } else {
          name = "Admin"; //comment['tutor']['name'];
          avatar = comment['tutor']['avatar'];
          // who = 'tutor';
        }
        date = comment['date_added'];

        commentsWidgets.add(new Container(
            decoration: new BoxDecoration(
              color: Color.fromRGBO(107, 43, 20, 0.2),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            // alignment: who == "me" ? Alignment.centerRight : Alignment.centerLeft,
            alignment: Alignment.topRight,
            width: screen(context).width, // * 0.8,
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 20,
                    backgroundColor: brown,
                    backgroundImage: NetworkImage('$baseUrl/$avatar', headers: {
                      'cache-control': 'max-age=0, must-revalidate'
                    })),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("$name",
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        color: brown,
                                        fontWeight: FontWeight.bold)),
                                // Expanded(child:
                                Text("$date",
                                    maxLines: 1,
                                    style: TextStyle(color: brown)),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            Text(
                              "${comment['comment']}",
                              textAlign: TextAlign.start,
                            )
                          ],
                        ))),
              ],
            )));
      });

      setState(() {
        _commentWidgets = commentsWidgets;
      });
    } catch (e) {
      error(context, stripExceptions(e));
    }
  }

  // Future loadPdf(Tutorial tutorial) async {
  //   if (tutorial.currentTutorial!.tablature != null) {
  //     _pdfDocument = await PDFDocument.fromURL(
  //         "$baseUrl/${tutorial.currentTutorial!.tablature!}");
  //   }
  // }

  Widget renderDisplayScreen(Tutorial tutorial) {
    if (_displayscreen == Screen.video) {
      return Container(
          height: (screen(context).width * 2) / 3,
          width: screen(context).width,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: NetworkImage(
                  Uri.parse('$baseUrl/${tutorial.currentTutorial!.thumbnail}')
                      .toString(),
                  headers: {'cache-control': 'max-age=0, must-revalidate'}),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: VideoWidget(
            play: true,
            url: "$baseUrl/${tutorial.currentTutorial!.video}",
          ));
    } else if (_displayscreen == Screen.audio) {
      return Container(
          height: (screen(context).width * 2) / 3,
          child: Column(children: [
            Expanded(
              child: Image.asset(
                "assets/imgs/icons/playing_audio.png",
                fit: BoxFit.fitWidth,
                matchTextDirection: true,
                excludeFromSemantics: true,
              ),
            ),
            AudioWidget(
                play: true,
                url: "$baseUrl/${tutorial.currentTutorial!.audio}",
                loop: false)
          ]));
    } else if (_displayscreen == Screen.practice) {
      return Container(
          height: (screen(context).width * 2) / 3,
          child: Column(children: [
            Expanded(
              child: Image.asset(
                "assets/imgs/icons/playing_audio.png",
                fit: BoxFit.fitWidth,
                matchTextDirection: true,
                excludeFromSemantics: true,
              ),
            ),
            AudioWidget(
                play: true,
                url: "$baseUrl/${tutorial.currentTutorial!.practice}",
                loop: true)
          ]));
    } else if (_displayscreen == Screen.tablature) {
      return Container(
          height: screen(context).height * 0.6,
          child: PdfWidget(
              url: "$baseUrl/${tutorial.currentTutorial!.tablature}"));
    }
    // No Audio/Video/Practie/Tablature
    return Center(
        child: Icon(Icons.cancel_presentation_rounded, size: 200, color: grey));
  }

  void nextLesson(StudentStudyStatistics studentStats, Courses courses,
      Lessons lessons, Tutorial tutorial) async {
    try {
      loading(context);
      // get the index of the current tutorial in the tutorial lessons list
      int currentIndex =
          tutorial.tutorialLessons!.indexOf(tutorial.currentTutorial!);

      // use the index to get the next lesson if this lesson is not the last
      if (tutorial.currentTutorial != tutorial.tutorialLessons!.last) {
        tutorial.setCurrentTutorial(
            tutorial.tutorialLessons!.elementAt(currentIndex + 1));
        if (lessons.source == LessonSource.normal)
          await lessons.activateLesson(studentStats, courses, tutorial);
        else if (lessons.source == LessonSource.featured)
          await lessons.activateFeaturedLesson(courses, tutorial);
        // then route to the lesson
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/tutorial_page');
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  void previousLesson(StudentStudyStatistics studentStats, Courses courses,
      Lessons lessons, Tutorial tutorial) async {
    try {
      loading(context);
      // get the index of the current tutorial in the tutorial lessons list
      int currentIndex =
          tutorial.tutorialLessons!.indexOf(tutorial.currentTutorial!);

      // use the index to get the previous lesson if this lesson is not the first
      if (tutorial.currentTutorial != tutorial.tutorialLessons?.first) {
        tutorial.setCurrentTutorial(
            tutorial.tutorialLessons!.elementAt(currentIndex - 1));

        if (lessons.source == LessonSource.normal)
          await lessons.activateLesson(studentStats, courses, tutorial);
        else if (lessons.source == LessonSource.featured)
          await lessons.activateFeaturedLesson(courses, tutorial);
        // then route to the lesson
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/tutorial_page');
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Student>(builder: (BuildContext context, student, child) {
      return Consumer<StudentStudyStatistics>(
          builder: (BuildContext context, studentStats, child) {
        return Consumer<Courses>(
            builder: (BuildContext context, courses, child) {
          return Consumer<Lessons>(
              builder: (BuildContext context, lessons, child) {
            return Consumer<Tutorial>(
                builder: (BuildContext context, tutorial, child) {
              return SafeArea(
                  top: true,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(
                          _displayscreen == Screen.tablature
                              ? screen(context).height * 0.6
                              : (screen(context).width * 2) / 3),
                      child: renderDisplayScreen(tutorial),
                    ),
                    body: Column(children: [
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(children: <Widget>[
                          Container(
                              width: screen(context).width,
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // the tutorial options
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: tutorial
                                                    .currentTutorial!.video !=
                                                null
                                            ? () => setState(() =>
                                                _displayscreen = Screen.video)
                                            : () => snackbar(context,
                                                "There is no video for this lesson, check others."),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Video",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: _displayscreen ==
                                                          Screen.video
                                                      ? brown
                                                      : tutorial.currentTutorial!
                                                                  .video !=
                                                              null
                                                          ? darkgrey
                                                          : Colors.grey[350]),
                                            ),
                                            _displayscreen == Screen.video
                                                ? Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    height: 5,
                                                    margin:
                                                        EdgeInsets.only(top: 2),
                                                    width: 45,
                                                    color: brown,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: tutorial
                                                    .currentTutorial!.audio !=
                                                null
                                            ? () => setState(() =>
                                                _displayscreen = Screen.audio)
                                            : () => snackbar(context,
                                                "There is no audio for this lesson, check others."),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Audio",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: _displayscreen ==
                                                          Screen.audio
                                                      ? brown
                                                      : tutorial.currentTutorial!
                                                                  .audio !=
                                                              null
                                                          ? darkgrey
                                                          : Colors.grey[350]),
                                            ),
                                            _displayscreen == Screen.audio
                                                ? Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    height: 5,
                                                    margin:
                                                        EdgeInsets.only(top: 2),
                                                    width: 45,
                                                    color: brown,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: tutorial.currentTutorial!
                                                    .practice !=
                                                null
                                            ? () => setState(() =>
                                                _displayscreen =
                                                    Screen.practice)
                                            : () => snackbar(context,
                                                "There is no practice loop for this lesson, check others."),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Practice Loop",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: _displayscreen ==
                                                          Screen.practice
                                                      ? brown
                                                      : tutorial.currentTutorial!
                                                                  .practice !=
                                                              null
                                                          ? darkgrey
                                                          : Colors.grey[350]),
                                            ),
                                            _displayscreen == Screen.practice
                                                ? Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    height: 5,
                                                    margin:
                                                        EdgeInsets.only(top: 2),
                                                    width: 45,
                                                    color: brown,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: tutorial.currentTutorial!
                                                    .tablature !=
                                                null
                                            ? () => setState(() =>
                                                _displayscreen =
                                                    Screen.tablature)
                                            : () => snackbar(context,
                                                "There is no tablature for this lesson, check others."),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Tablature",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: _displayscreen ==
                                                          Screen.tablature
                                                      ? brown
                                                      : tutorial.currentTutorial!
                                                                  .tablature !=
                                                              null
                                                          ? darkgrey
                                                          : Colors.grey[350]),
                                            ),
                                            _displayscreen == Screen.tablature
                                                ? Container(
                                                    alignment:
                                                        Alignment.topRight,
                                                    height: 5,
                                                    margin:
                                                        EdgeInsets.only(top: 2),
                                                    width: 45,
                                                    color: brown,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                  // The text contents
                                  Text(
                                    tutorial.currentTutorial!.title!,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: brown,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    tutorial.currentTutorial!.tutor!,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: darkgrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "${tutorial.currentTutorial!.description}",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: darkgrey,
                                      fontSize: 15,
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  // Read more indication
                                  tutorial.currentTutorial!.note != null
                                      ? TextButton(
                                          onPressed: () => setState(
                                              () => _showNote = !_showNote),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Notes',
                                                  style: TextStyle(
                                                      color: brown,
                                                      fontSize: 16)),
                                              SizedBox(width: 2),
                                              Icon(
                                                  _showNote
                                                      ? Icons.arrow_drop_up
                                                      : Icons.arrow_drop_down,
                                                  color: brown)
                                            ],
                                          ))
                                      : Container(),

                                  // lesson Note
                                  tutorial.currentTutorial!.note != null &&
                                          _showNote == true
                                      ? Text(
                                          tutorial.currentTutorial!.note ??
                                              "No notes",
                                          style: TextStyle(
                                            color: darkgrey,
                                            fontSize: 15,
                                          ),
                                        )
                                      : Container(),

                                  // the previous/next
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Previous lesson
                                      tutorial.currentTutorial !=
                                              tutorial.tutorialLessons?.first
                                          ? MaterialButton(
                                              onPressed: () {
                                                previousLesson(studentStats,
                                                    courses, lessons, tutorial);
                                              },
                                              color: brown,
                                              textColor: Colors.white,
                                              child: Text('PREVIOUS',
                                                  style:
                                                      TextStyle(fontSize: 16)))
                                          : Container(),

                                      // Next lesson
                                      tutorial.currentTutorial !=
                                              tutorial.tutorialLessons?.last
                                          ? MaterialButton(
                                              onPressed: () {
                                                nextLesson(studentStats,
                                                    courses, lessons, tutorial);
                                              },
                                              color: brown,
                                              textColor: Colors.white,
                                              child: Text('NEXT',
                                                  style:
                                                      TextStyle(fontSize: 16)))
                                          : (
                                                  // tutorialLessonsIsLoadedFromCourse ==
                                                  //           true &&
                                                  lessons.source ==
                                                      LessonSource.normal)
                                              ? courses.currentCourse!
                                                          .completedLessons ==
                                                      courses.currentCourse!
                                                          .allLessons
                                                  ? MaterialButton(
                                                      onPressed: () {
                                                        // if this course is the last course in the category,
                                                        // show the completed category page
                                                        // else show the completed courses page
                                                        if (courses
                                                                .studyingCourses
                                                                .last ==
                                                            courses
                                                                .currentCourse) {
                                                          print('True This');
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  '/completedcategory');
                                                        } else {
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  context,
                                                                  '/completedcourses');
                                                        }
                                                      },
                                                      color: brown,
                                                      textColor: Colors.white,
                                                      child: Text(
                                                        'COMPLETE',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    )
                                                  : Container()
                                              : Container() // use this if this is not a course
                                    ],
                                  ),

                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        snackbar(
                                            context, 'Downloading Lesson...');
                                        if (tutorial.currentTutorial!.video !=
                                            null) {
                                          await downloadFile(tutorial
                                                  .currentTutorial!.video!)
                                              .then(
                                            (value) => {
                                              snackbar(context,
                                                  'Video Lesson downloaded.')
                                            },
                                          );
                                        }
                                        if (tutorial.currentTutorial!.audio !=
                                            null) {
                                          await downloadFile(tutorial
                                                  .currentTutorial!.audio!)
                                              .then(
                                            (value) => {
                                              snackbar(context,
                                                  'Audio Lesson downloaded.')
                                            },
                                          );
                                        }
                                        if (tutorial
                                                .currentTutorial!.practice !=
                                            null) {
                                          await downloadFile(tutorial
                                                  .currentTutorial!.practice!)
                                              .then(
                                            (value) => {
                                              snackbar(context,
                                                  'Practice Loop downloaded.')
                                            },
                                          );
                                        }
                                        if (tutorial
                                                .currentTutorial!.tablature !=
                                            null) {
                                          await downloadFile(tutorial
                                                  .currentTutorial!.tablature!)
                                              .then(
                                            (value) => {
                                              snackbar(context,
                                                  'Tablature downloaded.')
                                            },
                                          );
                                        }
                                      } catch (e) {
                                        snackbar(context, stripExceptions(e));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.download),
                                        SizedBox(width: 5),
                                        Text(
                                          'Download Lesson',
                                          style: TextStyle(
                                            color: brown,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () => setState(
                                        () => _showComment = !_showComment),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Comments',
                                          style: TextStyle(
                                            color: brown,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                            _showComment
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            color: brown)
                                      ],
                                    ),
                                  ),

                                  _showComment == true
                                      ? Column(
                                          children: _commentWidgets,
                                        )
                                      : Container()
                                ],
                              )),
                        ])),
                      ),

                      // comment section
                      Container(
                        // height: 50,
                        padding: EdgeInsets.all(0),
                        width: screen(context).width,
                        // color: Colors.white,
                        decoration: BoxDecoration(
                            color: grey,
                            border: Border(
                              bottom: BorderSide(width: 2.0, color: brown),
                              // width: 1.0, color: brown
                            )),
                        child: TextField(
                          controller: _comment,
                          autocorrect: true,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) {
                            _submitComment(student, tutorial);
                          },
                          style: TextStyle(fontSize: 20.0, color: brown),
                          decoration: InputDecoration(
                            hintText: "Ask question",
                            suffix: IconButton(
                              onPressed: () {
                                _submitComment(student, tutorial);
                              },
                              icon: Icon(
                                Icons.send,
                                color: brown,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ));
            });
          });
        });
      });
    });
  }
}
