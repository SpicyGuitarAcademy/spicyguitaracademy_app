import 'package:spicyguitaracademy_app/utils/functions.dart';

class Lesson {
  // the properties on the class
  int? id;
  int? courseId;
  String? title;
  String? description;
  int? order;
  String? thumbnail;
  String? tutor;
  String? video;
  String? audio;
  String? practice;
  String? tablature;
  String? note;

  Lesson();

  // constructing from json
  Lesson.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    courseId = int.parse(json['course']);
    title = parseHtmlString(json['lesson'] ?? 'No title');
    description = parseHtmlString(json['description'] ?? 'No description');
    order = int.parse(json['ord']);
    thumbnail = json['thumbnail'];
    tutor = json['tutor'] ?? 'No tutor';
    video = json['high_video'] ?? null;
    audio = json['audio'] ?? null;
    practice = json['practice_audio'] ?? null;
    tablature = json['tablature'] ?? null;
    note = json['note'] ?? null;
    note = note != null ? parseHtmlString(note) : note;
  }
}
