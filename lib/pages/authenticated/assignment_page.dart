import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/providers/StudentAssignments.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';
import 'package:spicyguitaracademy_app/utils/functions.dart';
import 'package:spicyguitaracademy_app/widgets/custom_audio_player.dart';
import 'package:spicyguitaracademy_app/widgets/custom_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spicyguitaracademy_app/widgets/modals.dart';

class AssignmentPage extends StatefulWidget {
  AssignmentPage();

  @override
  AssignmentPageState createState() => new AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage> {
  bool shouldUpload = true;
  File? file;
  TextEditingController _answer = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future _uploadAnswer(Courses courses, String type,
      StudentAssignments studentAssignments) async {
    FilePickerResult? result;
    try {
      switch (type) {
        case 'image':
          result = await FilePicker.platform.pickFiles(type: FileType.image);
          break;
        case 'audio':
          result = await FilePicker.platform.pickFiles(type: FileType.audio);
          break;
        case 'video':
          result = await FilePicker.platform.pickFiles(type: FileType.video);
          break;
        default:
      }

      if (result != null) {
        File file = File(result.files.single.path!);
        loading(context, message: 'Uploading');

        dynamic response = await studentAssignments.uploadAnswer(
            file, courses, type, assignment!);
        Navigator.pop(context);
        if (response['status'] == true) {
          success(context, "Assignment uploaded.");
          setState(() {
            shouldUpload = true;
          });
          _getAssignmentAnswers();
        } else {
          error(context, response['message']);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  Future _submitAnswer(
      Courses courses, StudentAssignments studentAssignments) async {
    try {
      loading(context, message: 'Submitting');
      dynamic response = await studentAssignments.submitAnswer(
          courses, _answer.text, assignment!);
      if (response['status'] == true) {
        setState(() {
          shouldUpload = true;
        });
        _answer.clear();
        Navigator.pop(context);
        success(context, "Text assignment submitted.");
        _getAssignmentAnswers();
      } else {
        throw new Exception(response['message']);
      }
    } catch (e) {
      Navigator.pop(context);
      error(context, stripExceptions(e));
    }
  }

  List<Widget> assignmentAnswers = [];
  bool hasFetchedAnswers = false;

  Future _getAssignmentAnswers() async {
    try {
      Courses courses = context.read<Courses>();
      StudentAssignments studentAssignments =
          context.read<StudentAssignments>();
      await studentAssignments.getAssignmentAnswers(courses, assignment!);
    } catch (e) {
      error(context, stripExceptions(e));
    }
  }

  List<Widget> renderAssignmentAnswers(
      Courses courses, StudentAssignments studentAssignments) {
    List<Widget> assignmentAnswers = [];

    if (Answers.answers!.length > 0)
      Answers.answers!.forEach((Answer answer) {
        if (answer.isTutor == true) {
          // assignmentAnswers.add(SizedBox(height: 7));
          assignmentAnswers.add(Row(
            children: [
              Icon(
                Icons.shield,
                color: brown,
                size: 14,
              ),
              Expanded(
                child: Text("Admin",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              )
            ],
          ));
        } else {
          // assignmentAnswers.add(SizedBox(height: 7));
          assignmentAnswers.add(Row(
            children: [
              Icon(
                Icons.person,
                color: brown,
                size: 16,
              ),
              Expanded(
                child: Text("Me",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              )
            ],
          ));
        }
        assignmentAnswers.add(SizedBox(height: 5));
        if (answer.type == 'text') {
          assignmentAnswers.add(
            renderTextContent(answer.content!),
          );
        } else if (answer.type == 'image') {
          assignmentAnswers.add(
            renderImageContent(answer.content!),
          );
        } else if (answer.type == 'audio') {
          assignmentAnswers.add(
            renderAudioContent(answer.content!),
          );
        } else if (answer.type == 'video') {
          assignmentAnswers.add(
            renderVideoContent(answer.content!),
          );
        }

        assignmentAnswers.add(SizedBox(height: 10));
      });
    else
      assignmentAnswers.add(
        Text(
          "No asnwer for this assignment yet.\nAdd an answer.",
          textAlign: TextAlign.center,
        ),
      );
    return assignmentAnswers;
  }

  @override
  void dispose() {
    super.dispose();
    Answers.status = false;
  }

  Widget renderTextContent(String content) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: new BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Text(content),
    );
  }

  Widget renderImageContent(String content) {
    return Container(
      width: screen(context).width,
      alignment: Alignment.centerLeft,
      decoration: new BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Image.network(
        "$baseUrl/$content",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget renderAudioContent(String content) {
    return Container(
      width: screen(context).width,
      alignment: Alignment.centerLeft,
      decoration: new BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: AudioWidget(
        play: true,
        url: "$baseUrl/$content",
        loop: false,
      ),
    );
  }

  Widget renderVideoContent(String content) {
    return Container(
      width: screen(context).width,
      height: ((screen(context).width) * 2) / 3,
      alignment: Alignment.centerLeft,
      decoration: new BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: VideoWidget(
        play: true,
        url: "$baseUrl/$content",
      ),
    );
  }

  late Assignment? assignment;
  bool _showMedia = false;

  List<Widget> renderAssignmentQuestions() {
    List<Widget>? questions = [];
    assignment!.questions!.forEach((Question question) {
      if (question.type == 'text') {
        questions.add(
          renderTextContent(question.content!),
        );
      } else if (question.type == 'image') {
        questions.add(
          renderImageContent(question.content!),
        );
      } else if (question.type == 'audio') {
        questions.add(
          renderAudioContent(question.content!),
        );
      } else if (question.type == 'video') {
        questions.add(
          renderVideoContent(question.content!),
        );
      }
      // questions.add(SizedBox(height: 5));

      questions.add(SizedBox(height: 10));
    });

    return questions;
  }

  @override
  Widget build(BuildContext context) {
    dynamic map = getRouteArgs(context);
    assignment = map['assignment'];

    if (assignment == null) {
      Navigator.pop(context);
    }

    return Consumer<Courses>(
      builder: (BuildContext context, courses, child) {
        return Consumer<StudentAssignments>(
          builder: (BuildContext context, studentAssignments, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("Question ${assignment!.assignmentNumber}"),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Question',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          ...renderAssignmentQuestions(),
                          Text(
                            'Answers',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          if (Answers.status == true)
                            ...renderAssignmentAnswers(
                                courses, studentAssignments),
                          if (Answers.status == false)
                            CircularProgressIndicator(),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),

                  // answer section
                  assignment!.rating! < 3
                      ? Container(
                          padding: EdgeInsets.all(0),
                          width: screen(context).width,
                          decoration: BoxDecoration(
                            color: grey,
                            border: Border(
                              bottom: BorderSide(width: 2, color: brown),
                            ),
                          ),
                          child: Column(
                            children: [
                              if (_showMedia == true) SizedBox(height: 5),
                              if (_showMedia == true)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      // send
                                      onPressed: () {
                                        _uploadAnswer(courses, 'video',
                                            studentAssignments);
                                      },
                                      child: Row(children: [
                                        Icon(
                                          Icons.movie,
                                        ),
                                        SizedBox(width: 5),
                                        Text('Video')
                                      ]),
                                    ),
                                    TextButton(
                                      // send
                                      onPressed: () {
                                        _uploadAnswer(courses, 'audio',
                                            studentAssignments);
                                      },
                                      child: Row(children: [
                                        Icon(
                                          Icons.audiotrack,
                                        ),
                                        SizedBox(width: 5),
                                        Text('Audio')
                                      ]),
                                    ),
                                    TextButton(
                                      // send
                                      onPressed: () {
                                        _uploadAnswer(courses, 'image',
                                            studentAssignments);
                                      },
                                      child: Row(children: [
                                        Icon(
                                          Icons.image,
                                        ),
                                        SizedBox(width: 5),
                                        Text('Image')
                                      ]),
                                    ),
                                  ],
                                ),
                              if (_showMedia == true) SizedBox(height: 5),
                              TextField(
                                controller: _answer,
                                autocorrect: true,
                                textInputAction: TextInputAction.send,
                                onChanged: (value) {
                                  if (value.trim().isEmpty)
                                    setState(() => shouldUpload = true);
                                  else
                                    setState(() => shouldUpload = false);
                                },
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    _submitAnswer(courses, studentAssignments);
                                  }
                                },
                                style: TextStyle(fontSize: 20, color: brown),
                                decoration: InputDecoration(
                                  hintText: "Enter text",
                                  suffix: shouldUpload == true
                                      ? IconButton(
                                          // upload answer
                                          onPressed: () {
                                            setState(() {
                                              _showMedia = !_showMedia;
                                            });
                                          },
                                          tooltip: "Upload assignment",
                                          icon: Icon(
                                            Icons.attachment,
                                            color: brown,
                                          ))
                                      : IconButton(
                                          // send
                                          onPressed: () {
                                            _submitAnswer(
                                                courses, studentAssignments);
                                          },
                                          tooltip: "Submit assignemnt",
                                          icon: Icon(
                                            Icons.send,
                                            color: brown,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
