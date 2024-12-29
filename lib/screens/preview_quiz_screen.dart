import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:quiz_app/widgets/custom_button.dart';

class PreviewQuizScreen extends StatelessWidget {
  final String quizTitle;
  final String quizCategory;
  final List<Map<String, dynamic>> questions;

  const PreviewQuizScreen({
    required this.quizTitle,
    required this.quizCategory,
    required this.questions,
  });

  Future<void> saveQuizToFirebase(BuildContext context) async {
    try {
      // Get the current user's UID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If the user is not authenticated, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to create a quiz.')),
        );
        return;
      }

      // Reference to Firestore
      final firestore = FirebaseFirestore.instance;

      // Save quiz data to Firestore under the "quizzes" collection
      await firestore.collection('quizzes').add({
        'quizTitle': quizTitle,
        'quizCategory': quizCategory,
        'questions': questions,
        'createdAt': Timestamp.now(),
        'createdBy': user.uid, // Save the user's UID to the 'createdBy' field
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz saved successfully!')),
      );

      // Navigate back to the main screen
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (error) {
      // Handle errors and show failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save quiz: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quiz Title: $quizTitle', style: TextStyle(fontSize: 18)),
            Text('Category: $quizCategory', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Q${index + 1}: ${question['question']}'),
                          ...List.generate(4, (optionIndex) {
                            return Text(
                              '${optionIndex + 1}. ${question['options'][optionIndex]}',
                              style: TextStyle(
                                color: question['correctOption'] == optionIndex
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Save Quiz',
              onPressed: () => saveQuizToFirebase(context),
            ),
          ],
        ),
      ),
    );
  }
}
