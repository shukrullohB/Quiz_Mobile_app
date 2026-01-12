import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_my2/screens/quiz_screen.dart';

import '../model/quiz_category.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<QuizCategory> categories = [
    QuizCategory(
      name: 'General Knowledge',
      icon: Icons.lightbulb_outline,
      color: Color(0xFF6C63FF),
      description:
      'Test your general knowledge with a variety of questions from different fields.',
      questionCount: 25,
    ),
    QuizCategory(
      name: 'Science',
      icon: Icons.science,
      color: Color(0xFF00C853),
      description:
      'Explore the wonders of science with questions on physics, chemistry, biology.',
      questionCount: 20,
    ),
    QuizCategory(
      name: 'History',
      icon: Icons.history,
      color: Color(0xFFE53935),
      description:
      'Dive into the past with questions on world history, events, and culture.',
      questionCount: 15,
    ),
    QuizCategory(
      name: 'Geography',
      icon: Icons.map,
      color: Color(0xFF0091EA),
      description:
      'Test your knowledge of geography with questions on countries, continents, and locations.',
      questionCount: 18,
    )
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(CurvedAnimation(
      parent: _fadeController, curve: Curves.easeInOut,)
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOut,));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.forward();
    _slideController.forward();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFE8EAFF),
              Color(0xFFF0F2FF),
            ],
          ),
        ),
        child: SafeArea(child: SingleChildScrollView(
          child: Padding(padding: EdgeInsetsGeometry.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome Back!",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF000000),
                                  ),),
                                SizedBox(height: 4),
                                Text('Your daily quiz awaits!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF4A5568)
                                  ),
                                ),
                              ]
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFEDF2F7).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.psychology,
                              size: 32,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 32),

                SlideTransition(position: _slideAnimation,
                  child: Container(
                    padding: EdgeInsets.all(20),
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
                    child: Row(
                      children: [
                        Expanded(child: _buildStatItem(
                          'Total Questions',
                          '120+',
                          Icons.quiz,
                          Color(0xFF6C63FF),
                        ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        Expanded(child: _buildStatItem(
                          'Categories',
                          '6',
                          Icons.category,
                          Color(0xFF4ECDC4),
                        )),
                        //2_part
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        Expanded(child: _buildStatItem(
                          'Difficulty',
                          'Mixed',
                          Icons.trending_up,
                          Color(0xFFFFB74D),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                FadeTransition(opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(20),
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
                    child: Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quick Start",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Jump into a random quiz.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4A5568),
                              ),
                            ),
                          ],
                        ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            final randomCategory =
                                (categories.toList()..shuffle()).first;
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  category: randomCategory,
                                ),
                            ),);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "Start Quiz",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                FadeTransition(opacity: _fadeAnimation,
                  child: Text('Choose a Category',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                  ),
                  ),
                ),
                SizedBox(height: 16),
                SlideTransition(position: _slideAnimation,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context,index) {
                      return CategoryCard(
                        category: categories[index],
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuizScreen(category: categories[index],
                            ),
                          ),);
                        },
                      );
                    },

                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildStatItem(
      String title, 
      String value,
      IconData icon,
      Color color,
      ) {
         return Column(
          children: [
            Icon(icon, size: 24, color: color,),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Color(0xFF4A5568)),)
          ]
         );
  }
}
