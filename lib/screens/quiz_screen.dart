import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TakeQuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Quiz'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading quizzes: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No quizzes available.'));
          }

          final quizzes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quizData = quizzes[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(quizData['quizTitle']),
                  subtitle: Text('Category: ${quizData['quizCategory']}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizDetailScreen(quizData: quizData),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuizDetailScreen extends StatefulWidget {
  final Map<String, dynamic> quizData;

  const QuizDetailScreen({required this.quizData});

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<int?> userAnswers = [];
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    userAnswers = List<int?>.filled(widget.quizData['questions'].length, null);
  }

  void checkAnswer(int selectedOption) {
    if (userAnswers[currentQuestionIndex] == null) {
      final correctOption =
          widget.quizData['questions'][currentQuestionIndex]['correctOption'];
      if (selectedOption == correctOption) {
        score++;
      }
      setState(() {
        userAnswers[currentQuestionIndex] = selectedOption;
        if (currentQuestionIndex < widget.quizData['questions'].length - 1) {
          currentQuestionIndex++;
        } else {
          _showScoreDialog();
        }
      });
    }
  }

  // Validate if all questions are answered
  bool validateAnswers() {
    for (var answer in userAnswers) {
      if (answer == null) {
        return false;
      }
    }
    return true;
  }

  void _showScoreDialog() async {
    if (!validateAnswers()) {
      // Show error if any question is unanswered
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please answer all questions before submitting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close error dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Proceed to show the score without saving it
    setState(() {
      isSubmitting = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Display the score
      _showSuccessDialog();
    }
  }

  void _showErrorDialog(dynamic error) {
    String errorMessage =
        'There was an error saving your result. Please try again later.';
    if (error is FirebaseException) {
      errorMessage = 'Firebase Error: ${error.message}';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the error dialog
              setState(() {
                isSubmitting = false; // Stop loading indicator on error
              });
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    setState(() {
      isSubmitting = false; // Stop loading indicator on success
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed'),
        content:
            Text('Your score: $score/${widget.quizData['questions'].length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the success dialog
              Navigator.popUntil(
                  context, (route) => route.isFirst); // Go back to home
            },
            child: Text('Go to Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quizData['questions'] as List<dynamic>;
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizData['quizTitle']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion['question'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...List.generate(currentQuestion['options'].length, (index) {
              return RadioListTile<int>(
                value: index,
                groupValue: userAnswers[currentQuestionIndex],
                title: Text(currentQuestion['options'][index]),
                onChanged: (value) => checkAnswer(index),
              );
            }),
            if (isSubmitting) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
