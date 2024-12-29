import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final DateTime timestamp;

  Result({
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
  });

  // Convert a Result to a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': timestamp,
    };
  }

  // Convert a Map to a Result (for loading from Firestore)
  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      quizId: map['quizId'],
      userId: map['userId'],
      score: map['score'],
      totalQuestions: map['totalQuestions'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
