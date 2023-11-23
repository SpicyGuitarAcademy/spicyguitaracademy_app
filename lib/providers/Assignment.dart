class Assignments {
  static bool? status;
  static int? rating;
  static List<Assignment>? assignments = [];

  Assignments.fromMap(Map<String, dynamic> map) {
    try {
      rating = int.parse(map['rating']);

      List<Assignment> tempAssignments = [];
      map['assignments'].forEach((assignment) {
        tempAssignments.add(Assignment.fromMap(assignment));
      });
      assignments = tempAssignments;
    } catch (e) {
      throw new Exception('Could not convert map to assignments');
    }
  }
}

class Assignment {
  int? id;
  int? assignmentNumber;
  int? rating;
  late List<Question>? questions = [];

  Assignment.fromMap(Map<String, dynamic> map) {
    try {
      id = int.parse(map['id']);
      assignmentNumber = int.parse(map['assignment_number']);
      rating = int.parse(map['rating']);

      List<Question> tempQuestions = [];
      map['questions'].forEach((question) {
        tempQuestions.add(Question.fromMap(question));
      });
      questions = tempQuestions;

      print(tempQuestions);
    } catch (e) {
      throw new Exception('Could not convert map to assignment');
    }
  }
}

class Question {
  int? id;
  String? type;
  String? content;
  int? assignmentOrder;

  Question.fromMap(Map<String, dynamic> map) {
    try {
      id = int.parse(map['id']);
      type = map['type'];
      content = map['content'];
      assignmentOrder = int.parse(map['assignment_order']);
    } catch (e) {
      throw new Exception('Could not convert map to question');
    }
  }
}

class Answers {
  static bool? status;
  static List<Answer>? answers = [];

  Answers.fromMap(List<dynamic> map) {
    try {
      List<Answer> tempAnswers = [];
      map.forEach((answer) {
        tempAnswers.add(Answer.fromMap(answer));
      });
      answers = tempAnswers;
    } catch (e) {
      throw new Exception('Could not convert map to answers');
    }
  }
}

class Answer {
  int? id;
  String? type;
  String? content;
  bool? isTutor;
  String? tutor;

  Answer.fromMap(Map<String, dynamic> map) {
    try {
      id = int.parse(map['id']);
      type = map['type'];
      content = map['content'];
      tutor = map['tutor'] ?? "";
      isTutor = tutor != "";
    } catch (e) {
      throw new Exception('Could not convert map to answer');
    }
  }
}
