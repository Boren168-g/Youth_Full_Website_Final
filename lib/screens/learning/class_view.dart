import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ClassViewScreen extends StatefulWidget {
  final String className;
  const ClassViewScreen({super.key, required this.className});

  @override
  State<ClassViewScreen> createState() => _ClassViewScreenState();
}

class _ClassViewScreenState extends State<ClassViewScreen> {
  int _activeLessonIndex = 0;
  int _activeTab = 0; // 0: Lessons, 1: Practice Editor
  final List<int> _completedLessons = [];
  late ConfettiController _confettiController;

  // Quiz State
  int? _selectedOption;
  bool _quizSubmitted = false;
  bool _isCorrect = false;

  // IDE State
  final _codeController = TextEditingController(text: 'print("Hello, Code4Youth!")\n\ndef welcome():\n    print("Welcome to the world of coding")\n\nwelcome()');
  String _terminalOutput = '> Click Run to execute your code...';
  bool _isRunning = false;

  final Map<String, dynamic> _classData = {
    'CodeStarter': {
      'color': const Color(0xFF00C9A7),
      'lessons': [
        {
          'title': 'Introduction to Scratch',
          'type': 'video',
          'content': 'Learn the basics of block coding by creating your first animation. Scratch is a visual programming language where you drag and drop blocks to create stories, games, and animations.',
          'videoUrl': 'https://www.youtube.com/watch?v=scratch1'
        },
        {
          'title': 'The Logic of Loops',
          'type': 'quiz',
          'content': 'Understanding how computers repeat tasks using loops.',
          'question': 'Which block in Scratch is used to repeat an action forever?',
          'options': ['repeat 10', 'if then', 'forever', 'wait 1 sec'],
          'answerIndex': 2,
        },
        {
          'title': 'Variable Basics',
          'type': 'video',
          'content': 'Variables are like containers that store information. Learn how to create scores and timers in your games.',
          'videoUrl': 'https://www.youtube.com/watch?v=variables'
        },
        {
          'title': 'Input & Output Quiz',
          'type': 'quiz',
          'content': 'Checking your knowledge on how users interact with programs.',
          'question': 'What Scratch block allows a user to type in a value?',
          'options': ['say hello', 'ask and wait', 'broadcast', 'move 10 steps'],
          'answerIndex': 1,
        },
        {
          'title': 'First Mini Game',
          'type': 'project',
          'content': 'Follow the guide to build a "Catch the Apple" game. You will use everything you learned: loops, variables, and logic.',
          'resources': ['Assets Pack', 'Code Logic PDF', 'Starter Template'],
        },
      ]
    },
    'WebBuilders': {
      'color': const Color(0xFF1E3FCE),
      'lessons': [
        {
          'title': 'HTML Structure',
          'type': 'video',
          'content': 'Understanding the skeleton of every website: tags, elements, and attributes. Every webpage starts with a <!DOCTYPE html> declaration.',
          'videoUrl': 'https://www.youtube.com/watch?v=html1'
        },
        {
          'title': 'Tags & Elements Quiz',
          'type': 'quiz',
          'content': 'Identifying the building blocks of HTML.',
          'question': 'Which HTML tag is used to create the largest heading?',
          'options': ['<head>', '<h6>', '<header>', '<h1>'],
          'answerIndex': 3,
        },
        {
          'title': 'Styling with CSS',
          'type': 'video',
          'content': 'Bring your site to life with colors, fonts, and layouts using Cascading Style Sheets (CSS).',
          'videoUrl': 'https://www.youtube.com/watch?v=css1'
        },
        {
          'title': 'The CSS Box Model',
          'type': 'quiz',
          'content': 'Understanding padding, border, and margin.',
          'question': 'In the CSS Box Model, what is the space between the content and the border called?',
          'options': ['Margin', 'Padding', 'Gap', 'Outline'],
          'answerIndex': 1,
        },
        {
          'title': 'Modern Layouts with Flexbox',
          'type': 'video',
          'content': 'Learn the industry standard for creating responsive and flexible layouts that work on any screen size.',
          'videoUrl': 'https://www.youtube.com/watch?v=flexbox'
        },
      ]
    },
    'AI Lab': {
      'color': const Color(0xFFFF6B35),
      'lessons': [
        {
          'title': 'Python for AI',
          'type': 'video',
          'content': 'Why Python is the king of AI. Introduction to libraries like NumPy and Pandas.',
          'videoUrl': 'https://www.youtube.com/watch?v=pythonai'
        },
        {
          'title': 'Data Types in Python',
          'type': 'quiz',
          'content': 'Reviewing Python syntax and structures.',
          'question': 'Which Python data structure is defined using curly braces {} and stores key-value pairs?',
          'options': ['List', 'Tuple', 'Dictionary', 'Set'],
          'answerIndex': 2,
        },
        {
          'title': 'Linear Regression',
          'type': 'project',
          'content': 'Predict house prices using your first ML model. We will use scikit-learn to train a simple regressor.',
          'resources': ['Dataset.csv', 'Colab Notebook', 'Python Script'],
        },
        {
          'title': 'Machine Learning Concepts',
          'type': 'quiz',
          'content': 'Test your understanding of Supervised vs Unsupervised learning.',
          'question': 'What type of learning uses labeled data to train models?',
          'options': ['Reinforcement', 'Unsupervised', 'Supervised', 'Neural'],
          'answerIndex': 2,
        },
        {
          'title': 'Deep Learning & Neural Networks',
          'type': 'video',
          'content': 'Deep dive into neurons, layers, and activation functions. How the brain inspires modern AI.',
          'videoUrl': 'https://www.youtube.com/watch?v=nn1'
        },
      ]
    },
  };

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _completedLessons.add(0);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _runCode() async {
    setState(() {
      _isRunning = true;
      _terminalOutput = 'Compiling...';
    });

    await Future.delayed(const Duration(seconds: 1));

    String code = _codeController.text;
    String output = '';

    if (code.contains('print')) {
      final matches = RegExp(r'print\("(.+?)"\)').allMatches(code);
      if (matches.isNotEmpty) {
        output = matches.map((m) => m.group(1)).join('\n');
      } else {
        output = 'Hello, Code4Youth!\nWelcome to the world of coding';
      }
    } else {
      output = 'Execution finished with no output.';
    }

    setState(() {
      _isRunning = false;
      _terminalOutput = output;
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      if (!_completedLessons.contains(index)) {
        _completedLessons.add(index);
        _confettiController.play();
      }
    });
  }

  void _submitQuiz(int correctIndex) {
    if (_selectedOption == null) return;
    setState(() {
      _quizSubmitted = true;
      _isCorrect = _selectedOption == correctIndex;
      if (_isCorrect) {
        _toggleComplete(_activeLessonIndex);
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _selectedOption = null;
      _quizSubmitted = false;
      _isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _classData[widget.className] ?? _classData['CodeStarter'];
    final color = data['color'] as Color;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.className, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Unit 1: Foundations', style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
              ],
            ),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0D0D2B),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: Colors.grey[200], height: 1),
            ),
            actions: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    '${_completedLessons.length}/${data['lessons'].length} COMPLETED',
                    style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 900;
              return Row(
                children: [
                  // Sidebar
                  if (!isMobile)
                    Container(
                      width: 320,
                      decoration: BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: Colors.grey[200]!))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sidebarTab(0, LucideIcons.bookOpen, 'Curriculum'),
                          _sidebarTab(1, LucideIcons.code2, 'Practice Editor'),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              itemCount: data['lessons'].length,
                              itemBuilder: (context, i) {
                                bool isActive = _activeLessonIndex == i && _activeTab == 0;
                                bool isDone = _completedLessons.contains(i);
                                return _sidebarLessonTile(i, data['lessons'][i], isActive, isDone, color);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Main Content
                  Expanded(
                    child: _activeTab == 0 
                      ? _buildLessonView(data, color, isMobile)
                      : _buildCodeEditor(color),
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [color, Colors.green, Colors.blue, Colors.pink, Colors.orange],
          ),
        ),
      ],
    );
  }

  Widget _sidebarTab(int index, IconData icon, String label) {
    bool isActive = _activeTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _activeTab = index;
          _resetQuiz();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        color: isActive ? Colors.grey[50] : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, size: 18, color: isActive ? const Color(0xFF0D0D2B) : Colors.grey),
            const SizedBox(width: 16),
            Text(label, style: GoogleFonts.outfit(fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? const Color(0xFF0D0D2B) : Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonView(Map<String, dynamic> data, Color color, bool isMobile) {
    final lesson = data['lessons'][_activeLessonIndex];
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media Placeholder / Video Player
          if (lesson['type'] == 'video')
            _buildMediaBox('https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200', LucideIcons.playCircle)
          else if (lesson['type'] == 'quiz')
            _buildMediaBox('https://images.unsplash.com/photo-1518133910546-b6c2fb7d79e3?w=1200', LucideIcons.helpCircle)
          else
            _buildMediaBox('https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=1200', LucideIcons.layout),
          
          const SizedBox(height: 40),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CHAPTER ${_activeLessonIndex + 1}', style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 11)),
                    const SizedBox(height: 8),
                    Text(lesson['title'], style: GoogleFonts.plusJakartaSans(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.w800, color: const Color(0xFF0D0D2B))),
                  ],
                ),
              ),
              if (lesson['type'] != 'quiz')
                ElevatedButton.icon(
                  onPressed: () => _toggleComplete(_activeLessonIndex),
                  icon: Icon(_completedLessons.contains(_activeLessonIndex) ? Icons.check : LucideIcons.checkCircle, size: 16),
                  label: Text(_completedLessons.contains(_activeLessonIndex) ? 'Completed' : 'Mark Done'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _completedLessons.contains(_activeLessonIndex) ? Colors.green : color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          if (lesson['type'] == 'quiz') 
            _buildQuizContent(lesson, color)
          else ...[
            Text('Overview', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0D0D2B))),
            const SizedBox(height: 16),
            Text(lesson['content'], style: GoogleFonts.outfit(fontSize: 16, height: 1.7, color: Colors.grey[700])),
          ],

          const SizedBox(height: 40),
          if (lesson.containsKey('resources')) ...[
            Text('Downloads', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0D0D2B))),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: (lesson['resources'] as List<String>).map((res) => _resourceChip(res, color)).toList()),
          ],

          const SizedBox(height: 64),
          Row(
            children: [
              if (_activeLessonIndex > 0)
                Expanded(child: _navBtn('Back', LucideIcons.chevronLeft, () {
                  setState(() => _activeLessonIndex--);
                  _resetQuiz();
                })),
              if (_activeLessonIndex > 0 && _activeLessonIndex < data['lessons'].length - 1) const SizedBox(width: 16),
              if (_activeLessonIndex < data['lessons'].length - 1)
                Expanded(child: _navBtn('Next Chapter', LucideIcons.chevronRight, () {
                  setState(() => _activeLessonIndex++);
                  _resetQuiz();
                }, isForward: true)),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMediaBox(String imgUrl, IconData icon) {
    return Container(
      width: double.infinity, height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D2B),
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover, opacity: 0.3),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Center(
        child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildQuizContent(Map<String, dynamic> lesson, Color color) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.helpCircle, color: color, size: 20),
              const SizedBox(width: 12),
              Text('MULTIPLE CHOICE', style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          Text(lesson['question'], style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0D0D2B))),
          const SizedBox(height: 32),
          ...List.generate(lesson['options'].length, (i) {
            bool isSelected = _selectedOption == i;
            bool isCorrectOption = i == lesson['answerIndex'];
            
            Color itemColor = Colors.white;
            Color borderColor = Colors.grey[200]!;
            if (isSelected) itemColor = color.withOpacity(0.05);
            if (isSelected) borderColor = color;
            if (_quizSubmitted && isCorrectOption) {
              itemColor = Colors.green.withOpacity(0.1);
              borderColor = Colors.green;
            }
            if (_quizSubmitted && isSelected && !isCorrectOption) {
              itemColor = Colors.red.withOpacity(0.1);
              borderColor = Colors.red;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _quizSubmitted ? null : () => setState(() => _selectedOption = i),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: itemColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor, width: 2)),
                  child: Row(
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, 
                          border: Border.all(color: isSelected ? color : Colors.grey[300]!, width: 2),
                          color: isSelected ? color : Colors.transparent,
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                      ),
                      const SizedBox(width: 16),
                      Text(lesson['options'][i], style: GoogleFonts.outfit(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: const Color(0xFF0D0D2B))),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          if (!_quizSubmitted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedOption == null ? null : () => _submitQuiz(lesson['answerIndex']),
                style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                child: const Text('Submit Answer', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          else
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: _isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Icon(_isCorrect ? LucideIcons.checkCircle2 : LucideIcons.alertCircle, color: _isCorrect ? Colors.green : Colors.red),
                      const SizedBox(width: 12),
                      Text(_isCorrect ? 'Excellent! You got it right.' : 'Not quite. Try again!', style: GoogleFonts.outfit(color: _isCorrect ? Colors.green[800] : Colors.red[800], fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (!_isCorrect)
                  TextButton(onPressed: _resetQuiz, child: Text('Try Again', style: TextStyle(color: color, fontWeight: FontWeight.bold))),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCodeEditor(Color color) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
            child: Row(
              children: [
                const Icon(LucideIcons.code, size: 20, color: Colors.blue),
                const SizedBox(width: 12),
                Text('playground.py', style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runCode,
                  icon: _isRunning ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.play, size: 14),
                  label: const Text('RUN CODE'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C9A7), foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _codeController,
              maxLines: null,
              expands: true,
              style: GoogleFonts.jetBrainsMono(color: const Color(0xFFD1D5DB), fontSize: 16, height: 1.6),
              decoration: const InputDecoration(contentPadding: EdgeInsets.all(32), border: InputBorder.none),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFF0D0D2B), border: Border(top: BorderSide(color: Colors.white10))),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.terminal, size: 14, color: Colors.white38),
                      const SizedBox(width: 8),
                      Text('TERMINAL OUTPUT', style: GoogleFonts.plusJakartaSans(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const Spacer(),
                      IconButton(onPressed: () => setState(() => _terminalOutput = '> Console cleared.'), icon: const Icon(LucideIcons.trash2, color: Colors.white24, size: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(_terminalOutput, style: GoogleFonts.jetBrainsMono(color: const Color(0xFF00C9A7), fontSize: 14, height: 1.5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarLessonTile(int i, Map<String, dynamic> lesson, bool isActive, bool isDone, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          _activeLessonIndex = i;
          _resetQuiz();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.05) : Colors.transparent,
          border: Border(left: BorderSide(color: isActive ? color : Colors.transparent, width: 4)),
        ),
        child: Row(
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.green : (isActive ? color.withOpacity(0.1) : Colors.grey[100]),
              ),
              child: Center(child: Icon(isDone ? Icons.check : (isActive ? Icons.play_arrow_rounded : null), size: 14, color: isDone ? Colors.white : color)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson['title'], style: GoogleFonts.outfit(fontSize: 14, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? const Color(0xFF0D0D2B) : Colors.grey[700])),
                  const SizedBox(height: 2),
                  Text(lesson['type'].toUpperCase(), style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resourceChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.fileDown, size: 16, color: color),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0D0D2B))),
        ],
      ),
    );
  }

  Widget _navBtn(String label, IconData icon, VoidCallback onTap, {bool isForward = false}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: isForward ? const SizedBox() : Icon(icon, size: 18),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (isForward) ...[const SizedBox(width: 8), Icon(icon, size: 18)],
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D0D2B),
        padding: const EdgeInsets.symmetric(vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey[200]!)),
        elevation: 0,
      ),
    );
  }
}
