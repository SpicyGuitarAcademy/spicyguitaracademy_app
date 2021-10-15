import 'package:spicyguitaracademy_app/utils/functions.dart';

class Course {
  // the properties on the class
  int? id;
  int? category;
  String? title;
  String? description;
  String? thumbnail;
  String? tutor;
  int? order;
  int? completedLessons;
  int? allLessons;
  bool? featured;
  double? featuredprice;
  String? preview;
  bool? status;

  Course();

  // constructing from json
  Course.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    category = int.parse(json['category']);
    title = parseHtmlString(json['course'] ?? 'No title');
    description = parseHtmlString(json['description'] ?? 'No description');
    thumbnail = json['thumbnail'] ?? '';
    tutor = json['tutor'] ?? 'No tutor';
    order = int.parse(json['ord'] ?? '0');
    completedLessons = int.parse(json['done'] ?? '0');
    allLessons = int.parse(json['total'] ?? '0');
    featured = json['featured'] == '1' ? true : false;
    featuredprice = double.parse(json['featuredprice'] ?? 0);
    preview = json['featured_preview_video'] ?? '';
    status = json['status'] ?? false;
  }
}
