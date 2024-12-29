class QuestionModel {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final int marks;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.marks,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'marks': marks,
    };
  }

  static QuestionModel fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'],
      options: List<String>.from(map['options']),
      correctAnswerIndex: map['correctAnswerIndex'],
      marks: map['marks'],
    );
  }
}
