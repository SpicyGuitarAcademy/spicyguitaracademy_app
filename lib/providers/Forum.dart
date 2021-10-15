import 'package:flutter/foundation.dart';
import 'package:spicyguitaracademy_app/providers/Auth.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/utils/exceptions.dart';
import 'package:spicyguitaracademy_app/utils/request.dart';

class Forum extends ChangeNotifier {
  List<dynamic>? comments;

  Future getForumMessages(StudentStudyStatistics studentStats) async {
    try {
      var resp = await request(
          '/api/forums/${studentStats.studyingCategory}/messages',
          method: 'GET',
          headers: {
            'JWToken': Auth.token!,
            'cache-control': 'max-age=6400000, must-revalidate'
          });

      return resp['data'] ?? [];
    } on AuthException catch (e) {
      throw (e);
    } catch (e) {
      throw (e);
    }
  }

  Future submitMessage(
      StudentStudyStatistics studentStats, comment, replyId) async {
    try {
      var resp = await request('/api/forum/message', method: 'POST', body: {
        'comment': comment,
        'categoryId': studentStats.studyingCategory.toString(),
        'replyId': replyId
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
