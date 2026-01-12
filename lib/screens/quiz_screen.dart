import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_my2/model/question.dart';
import 'package:quiz_my2/model/quiz_category.dart';
import 'package:quiz_my2/screens/result_screen.dart';
import '../widgets/answer_card.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? selectedAnswer;
  bool isAnswer = false;
  late AnimationController _progressController;
  late AnimationController _questionController;

  List<Question> questions = [
    Question(
      text: 'What is the capital of France?',
      options: ['Paris', 'London', 'Berlin', 'Madrid'],
      correctAnswer: 0,
    ),
    Question(
      text: 'Which planet is known as the Red Planet?',
      options: ['Mars', 'Venus', 'Jupiter', 'Saturn'],
      correctAnswer: 0,
    ),
    Question(
      text: 'What is the largest mammal in the world?',
      options: ['Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
      correctAnswer: 1,
    ),
    Question(
      text: 'Which country is known as the Land of the Rising Sun?',
      options: ['China', 'South Korea', 'Thailand', 'Japan'],
      correctAnswer: 1,
    ),
    Question(
      text: 'What is the largest ocean in the world?',
      options: ['Atlantic Ocean', 'Indian Ocean', 'Pacific Ocean', 'Arctic Ocean'],
      correctAnswer: 2,
    ),
    Question(
      text: 'Which famous scientist developed the theory of relativity?',
      options: ['Isaac Newton', 'Albert Einstein', 'Galileo Galilei', 'Stephen Hawking'],
      correctAnswer: 1,
    ),
    Question(
      text: 'What is the largest desert in the world?',
      options: ['Gobi Desert', 'Arabian Desert', 'Kalahari Desert', 'Sahara Desert'],
      correctAnswer: 3,
    ),
    Question(
      text: 'Where is the Great Pyramid of Giza located?',
      options: ['Greece', 'China', 'India', 'Egypt'],
      correctAnswer: 3,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _questionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _questionController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void selectAnswer(int answerIndex) {
    if(isAnswer) return;

    setState(() {
      selectedAnswer = answerIndex;
      isAnswer = true;
    });

    HapticFeedback.lightImpact();

    if(answerIndex == questions[_currentQuestionIndex].correctAnswer) {
      _score++;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if(_currentQuestionIndex < questions.length - 1) {
      _questionController.reset;
      setState(() {
        _currentQuestionIndex++;
        selectedAnswer = null;
        isAnswer = false;
      });
      _questionController.forward();
      _progressController.animateTo(
        (_currentQuestionIndex + 1) / questions.length,
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(
                score: _score,
                totalQuestions: questions.length,
                category: widget.category,
              ),
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[_currentQuestionIndex];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.category.color.withOpacity(0.1),
              widget.category.color.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(child: Padding(padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Expanded(child: Container(
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentQuestionIndex + 1) / questions.length,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.category.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),),
                Text(
                  '${_currentQuestionIndex + 1}/${questions.length}',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
              SizedBox(height: 32),
              FadeTransition(opacity: _questionController,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(question.text,
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Expanded(child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                   return FadeTransition(opacity: _questionController,
                   child: AnswerCard(
                     text: question.options[index],
                     isSelected: selectedAnswer == index,
                     isCorrect: isAnswer && index == question.correctAnswer,
                     isWrong:
                        isAnswer &&
                        index != question.correctAnswer &&
                        selectedAnswer == index,
                     onTap: () => selectAnswer(index),
                     color: widget.category.color,
                   ),
                   );
                  }),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
