import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/custom_button.dart';
import 'add_questions_screen.dart';

class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  String? quizTitle;
  String? quizCategory;
  int numberOfQuestions = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Quiz Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a quiz title'
                    : null,
                onSaved: (value) => quizTitle = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a category' : null,
                onSaved: (value) => quizCategory = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Questions'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => numberOfQuestions = int.parse(value!),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Next: Add Questions',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Navigate to Add Questions Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQuestionsScreen(
                          quizTitle: quizTitle!,
                          quizCategory: quizCategory!,
                          numberOfQuestions: numberOfQuestions,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
