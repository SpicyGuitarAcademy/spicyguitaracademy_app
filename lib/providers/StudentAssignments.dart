import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';
import 'package:spicyguitaracademy_app/utils/upload.dart';

class StudentAssignments extends ChangeNotifier {
  Future getAssigment(courseId) async {
    try {
      var resp = await request('/api/course/$courseId/assignment',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });
      if (resp['status'] == true) {
        Assignments.status = true;
        Assignments.fromMap(resp['data']);

        notifyListeners();
      } else {
        Assignments.status = false;
      }
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future getAssignmentAnswers(Courses courses, Assignment assignment) async {
    try {
      dynamic response = await request(
        '/api/student/course/${courses.currentCourse!.id.toString()}/assignment/${assignment.assignmentNumber.toString()}/answers',
        method: 'GET',
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      if (response['status'] == true) {
        Answers.status = true;
        Answers.fromMap(response['data']);

        notifyListeners();
      } else {
        return [];
      }
    } catch (e) {
      throw e;
    }
  }

  Future submitAnswer(
      Courses courses, String answer, Assignment assignment) async {
    try {
      dynamic response = await request(
        '/api/student/assignment/answer',
        method: 'POST',
        body: {
          'content': answer,
          'type': 'text',
          'assignmentNumber': assignment.assignmentNumber.toString(),
          'courseId': courses.currentCourse!.id.toString()
        },
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      return response;
    } catch (e) {
      throw (e);
    }
  }

  Future uploadAnswer(
      File file, Courses courses, String type, Assignment assignment) async {
    try {
      dynamic response = await upload(
        '/api/student/assignment/answer',
        'content',
        file,
        method: 'POST',
        body: {
          'type': type,
          'assignmentNumber': assignment.assignmentNumber.toString(),
          'courseId': courses.currentCourse!.id.toString()
        },
        headers: {
          'JWToken': Auth.token!,
          'cache-control': 'max-age=0, must-revalidate'
        },
      );

      return response;
    } catch (e) {
      throw e;
    }
  }
}
