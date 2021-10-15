import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/Lesson.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

class Tutorial extends ChangeNotifier {
  // the list of lessons in a tutorial used for moving forward and backward in the tutorial
  List<Lesson>? tutorialLessons = [];
  // a boolean to determine of the tutorial lessons are loaded from a course or some free lessons
  bool? tutorialLessonsIsLoadedFromCourse = false;
  // the current tutorial which is gotten from the lesson object
  Lesson? currentTutorial;

  List<dynamic>? comments;

  setCurrentTutorial(Lesson lesson) {
    currentTutorial = lesson;
  }

  Future getTutorialComments(context) async {
    try {
      var resp = await request('/api/lesson/${currentTutorial!.id}/comments',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=0, must-revalidate'
          });

      return resp['data'] ?? [];
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future submitComment(context, comment, id, tutor) async {
    try {
      var resp = await request('/api/commentlesson', method: 'POST', body: {
        'comment': comment,
        'lessonId': id.toString(),
        'receiver': tutor
      }, headers: {
        'JWToken': Auth.token!,
        'cache-control': 'max-age=0, must-revalidate'
      });

      return resp['status'] ?? false;
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }
}
