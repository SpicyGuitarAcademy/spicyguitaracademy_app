import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:spicyguitaracademy_app/providers/StudentStudyStatistics.dart';
import 'package:spicyguitaracademy_app/utils/constants.dart';

String parseHtmlString(String? htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}

screen(BuildContext context) {
  return MediaQuery.of(context).copyWith().size;
}

Map getRouteArgs(BuildContext context) {
  final Map args = ModalRoute.of(context)!.settings.arguments as Map;
  return args;
}

String getStudentCategoryThumbnail(StudentStudyStatistics studentStats,
    {int category = -1}) {
  switch (category > -1 ? category : studentStats.studyingCategory) {
    case 0:
      return defaultThumbnail;
    case 1:
      return beginnersThumbnail;
    case 2:
      return amateurThumbnail;
    case 3:
      return intermediateThumbnail;
    case 4:
      return advancedThumbnail;
    default:
      return defaultThumbnail;
  }
}

String stripExceptions(errmsg) {
  return errmsg.toString().replaceAll("Exception: ", "");
}
