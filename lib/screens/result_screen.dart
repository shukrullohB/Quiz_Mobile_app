import 'package:flutter/material.dart';
import 'package:quiz_my2/screens/quiz_screen.dart';
import '../model/quiz_category.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final QuizCategory category;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.category
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _animatedController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _animatedController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
    );
      _scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0).animate(
          CurvedAnimation(
            parent: _animatedController,
            curve: Curves.elasticOut,
          ),
        );
      _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0).animate(
          CurvedAnimation(
            parent: _animatedController,
            curve: Curves.easeInOut,
          ),
        );
      _animatedController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animatedController.dispose();
    super.dispose();
  }

  String get resultMessage {
    double percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 90) {
      return 'Excellent!';
    } else if (percentage >= 80) {
      return 'Very Good!';
    } else if (percentage >= 60) {
      return 'Good job!';
    } else if (percentage >= 40) {
      return 'You can do better!';
    } else {
      return 'Keep practicing!';
    }
  }

  Color get resultColor {
    double percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 90) {
      return Colors.green;
    }
    else if (percentage >= 80) {
      return Colors.greenAccent;
    }
    else if (percentage >= 60) {
      return Colors.yellowAccent;
    }
    else if (percentage >= 40) {
      return Colors.orange;
    }
    else {
      return Colors.redAccent;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:[
                resultColor.withOpacity(0.8),
                resultColor,
              ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: Center(
          child: Padding(padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(scale: _scaleAnimation, child: Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.emoji_emotions,
                        size: 80,
                        color: widget.category.color,
                      ),
                      SizedBox(height: 24),
                      Text(
                        resultMessage,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your Score',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                            text: '${widget.score}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: resultColor,
                            ),
                          children: [
                          TextSpan(
                            text: '/${widget.totalQuestions}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                SizedBox(height: 48),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(category: widget.category),
                              ),
                          );
                        },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text('Play Again',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),);
                        },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white, width: 2,),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text('Home',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),)
      )
    );
  }
}
