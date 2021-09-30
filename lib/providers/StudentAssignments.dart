import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Assignment.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Courses.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

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
        Assignment.status = true;
        Assignment.fromJson(resp['data']);
      } else {
        Assignment.status = false;
      }
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future submitAnswer(Courses courses, answer) async {
    try {
      await request('/api/student/assignment/answer', method: 'POST', body: {
        'note': answer,
        'answerId': Assignment.answerId.toString(),
        'assignment': Assignment.id.toString(),
        'courseId': courses.currentCourse!.id.toString()
      }, headers: {
        'JWToken': Auth.token!,
        'cache-control': 'max-age=0, must-revalidate'
      });
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  static uploadAnswer() {}
}
