import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/custom_button.dart';
import 'preview_quiz_screen.dart';

class AddQuestionsScreen extends StatefulWidget {
  final String quizTitle;
  final String quizCategory;
  final int numberOfQuestions;

  const AddQuestionsScreen({
    required this.quizTitle,
    required this.quizCategory,
    required this.numberOfQuestions,
  });

  @override
  _AddQuestionsScreenState createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  final _formKey = GlobalKey<FormState>();
  String? questionText;
  List<String> options = List.filled(4, '');
  int correctOptionIndex = 0;

  void saveQuestion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      questions.add({
        'question': questionText,
        'options': options,
        'correctOption': correctOptionIndex,
      });

      if (currentQuestionIndex + 1 < widget.numberOfQuestions) {
        setState(() {
          currentQuestionIndex++;
          _formKey.currentState!.reset();
          questionText = null;
          options = List.filled(4, '');
          correctOptionIndex = 0;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewQuizScreen(
              quizTitle: widget.quizTitle,
              quizCategory: widget.quizCategory,
              questions: questions,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Questions')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${currentQuestionIndex + 1} of ${widget.numberOfQuestions}",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Question Text',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter a question'
                      : null,
                  onSaved: (value) => questionText = value,
                ),
                SizedBox(height: 20),
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Option ${index + 1}',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter option ${index + 1}'
                          : null,
                      onSaved: (value) => options[index] = value!,
                    ),
                  );
                }),
                SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: correctOptionIndex,
                  decoration: InputDecoration(
                    labelText: 'Correct Option',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(4, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text('Option ${index + 1}'),
                    );
                  }),
                  onChanged: (value) => setState(() {
                    correctOptionIndex = value!;
                  }),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: currentQuestionIndex + 1 < widget.numberOfQuestions
                        ? 'Next Question'
                        : 'Preview Quiz',
                    onPressed: saveQuestion,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
