import 'package:spicyguitaracademy_app/utils/functions.dart';

class Assignment {
  static int? id;
  static int? answerId;
  static String? questionNote;
  static String? questionVideo;
  static String? tutor;
  static int? tutorId;
  static String? answerNote;
  static String? answerVideo;
  static int? answerRating;
  static String? answerReview;
  static DateTime? answerDate;
  static bool? status;

  Assignment.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    tutorId = int.parse(json['tutor_id']);
    answerId = int.parse(json['answerId']);
    tutor = json['tutor'] ?? 'No tutor';
    questionNote = json['questionNote'] ?? null;
    questionNote =
        questionNote != null ? parseHtmlString(questionNote) : questionNote;
    questionVideo =
        json['questionVideo'] == "NULL" ? null : json['questionVideo'] ?? null;
    answerNote = json['answerNote'] ?? null;
    answerNote = answerNote != null ? parseHtmlString(answerNote) : answerNote;
    answerRating = int.parse(json['rating']);
    answerReview = json['review'] ?? null;
    answerVideo = json['answerVideo'] ?? null;
    answerDate = DateTime.parse(json['answerDate']);
  }
}
