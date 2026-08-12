import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../providers/auth_provider.dart';
import 'package:confetti/confetti.dart';

class ClassViewScreen extends StatefulWidget {
  final String className;
  const ClassViewScreen({super.key, required this.className});

  @override
  State<ClassViewScreen> createState() => _ClassViewScreenState();
}

class _ClassViewScreenState extends State<ClassViewScreen> {
  int _activeLessonIndex = 0;
  int _activeTab = 0; // 0: Lessons, 1: Code Editor
  final List<int> _completedLessons = [];
  late ConfettiController _confettiController;

  // IDE State
  final _codeController = TextEditingController(text: 'print("Hello, Code4Youth!")\n\ndef welcome():\n    print("Welcome to the world of coding")\n\nwelcome()');
  String _terminalOutput = '> Click Run to execute your code...';
  bool _isRunning = false;

  final Map<String, dynamic> _classData = {
    'CodeStarter': {
      'color': const Color(0xFF00C9A7),
      'lessons': [
        {'title': 'Introduction to Scratch', 'type': 'video', 'content': 'Learn the basics of block coding by creating your first animation.', 'videoUrl': 'https://www.youtube.com/watch?v=scratch1'},
        {'title': 'Logic & Loops', 'type': 'quiz', 'questions': 5, 'content': 'Test your knowledge on repeat loops and if-statements.'},
        {'title': 'First Mini Game', 'type': 'project', 'content': 'Follow the guide to build a "Catch the Apple" game.', 'resources': ['Assets Pack', 'Code Logic PDF']},
      ]
    },
    'WebBuilders': {
      'color': const Color(0xFF1E3FCE),
      'lessons': [
        {'title': 'HTML Structure', 'type': 'video', 'content': 'Understanding the skeleton of every website: tags, elements, and attributes.', 'videoUrl': 'https://www.youtube.com/watch?v=html1'},
        {'title': 'Styling with CSS', 'type': 'video', 'content': 'Bring your site to life with colors, fonts, and layouts.', 'videoUrl': 'https://www.youtube.com/watch?v=css1'},
        {'title': 'Responsive Layouts', 'type': 'quiz', 'questions': 8, 'content': 'Can you build for mobile? Check your Flexbox skills.'},
      ]
    },
    'AI Lab': {
      'color': const Color(0xFFFF6B35),
      'lessons': [
        {'title': 'Python for AI', 'type': 'video', 'content': 'Why Python is the king of AI and how to use NumPy.', 'videoUrl': 'https://www.youtube.com/watch?v=pythonai'},
        {'title': 'Linear Regression', 'type': 'project', 'content': 'Predict house prices using your first ML model.', 'resources': ['Dataset.csv', 'Colab Notebook']},
        {'title': 'Neural Networks', 'type': 'video', 'content': 'Deep dive into neurons, layers, and activation functions.', 'videoUrl': 'https://www.youtube.com/watch?v=nn1'},
      ]
    },
  };

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _completedLessons.add(0); // Mock progress
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

    // Mock interpreter logic
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
      if (_completedLessons.contains(index)) {
        _completedLessons.remove(index);
      } else {
        _completedLessons.add(index);
        _confettiController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _classData[widget.className] ?? _classData['CodeStarter'];
    final color = data['color'] as Color;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF4F7F6),
          appBar: AppBar(
            title: Text(widget.className, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 18)),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0D0D2B),
            elevation: 0.5,
            actions: [
              if (_activeTab == 0)
                Center(child: Text('${_completedLessons.length}/${data['lessons'].length} COMPLETED', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: color))),
              const SizedBox(width: 16),
            ],
          ),
          body: Row(
            children: [
              // Enhanced Sidebar
              if (MediaQuery.of(context).size.width > 800)
                Container(
                  width: 300,
                  decoration: BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: Colors.grey[200]!))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Learning Path', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      _sidebarTab(0, Icons.menu_book_rounded, 'Curriculum'),
                      _sidebarTab(1, Icons.code_rounded, 'Practice Editor'),
                      const Divider(height: 32),
                      if (_activeTab == 0)
                        Expanded(
                          child: ListView.builder(
                            itemCount: data['lessons'].length,
                            itemBuilder: (context, i) {
                              bool isActive = _activeLessonIndex == i;
                              bool isDone = _completedLessons.contains(i);
                              return _sidebarLessonTile(i, data['lessons'][i], isActive, isDone, color);
                            },
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('Switch back to Curriculum to view lessons.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ),
                    ],
                  ),
                ),
              
              // Dynamic Main Area
              Expanded(
                child: _activeTab == 0 
                  ? _buildLessonView(data, color)
                  : _buildCodeEditor(color),
              ),
            ],
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
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: isActive ? Colors.grey[50] : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, size: 20, color: isActive ? const Color(0xFF0D0D2B) : Colors.grey),
            const SizedBox(width: 16),
            Text(label, style: GoogleFonts.outfit(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? const Color(0xFF0D0D2B) : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonView(Map<String, dynamic> data, Color color) {
    final lesson = data['lessons'][_activeLessonIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, height: 450,
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D2B),
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=1200'),
                fit: BoxFit.cover, opacity: 0.4,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(lesson['type'] == 'quiz' ? Icons.quiz : Icons.play_circle_fill, color: Colors.white, size: 80),
                  const SizedBox(height: 16),
                  Text(lesson['type'] == 'video' ? 'Click to Start Lesson Video' : 'Ready to Start Quiz?', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LESSON ${_activeLessonIndex + 1}', style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(lesson['title'], style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0D0D2B)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _toggleComplete(_activeLessonIndex),
                style: ElevatedButton.styleFrom(backgroundColor: _completedLessons.contains(_activeLessonIndex) ? Colors.green : color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(_completedLessons.contains(_activeLessonIndex) ? '✓ Completed' : 'Mark as Finished'),
              ),
            ],
          ),
          const Divider(height: 64),
          Text('About this lesson', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0D0D2B))),
          const SizedBox(height: 16),
          Text(lesson['content'], style: GoogleFonts.outfit(fontSize: 16, height: 1.6, color: Colors.grey[700])),
          const SizedBox(height: 40),
          if (lesson.containsKey('resources')) ...[
            Text('Learning Resources', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0D0D2B))),
            const SizedBox(height: 16),
            Wrap(spacing: 12, children: (lesson['resources'] as List<String>).map((res) => _resourceChip(res, color)).toList()),
          ],
          const SizedBox(height: 60),
          Row(
            children: [
              if (_activeLessonIndex > 0)
                Expanded(child: _navBtn('Previous', Icons.arrow_back, () => setState(() => _activeLessonIndex--))),
              if (_activeLessonIndex > 0 && _activeLessonIndex < data['lessons'].length - 1) const SizedBox(width: 16),
              if (_activeLessonIndex < data['lessons'].length - 1)
                Expanded(child: _navBtn('Next Lesson', Icons.arrow_forward, () => setState(() => _activeLessonIndex++), isForward: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeEditor(Color color) {
    return Column(
      children: [
        // Editor Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Icons.code, size: 20, color: Colors.blue),
              const SizedBox(width: 12),
              Text('playground.py', style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _isRunning ? null : _runCode,
                icon: _isRunning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.play_arrow_rounded),
                label: const Text('Run Code'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0),
              ),
            ],
          ),
        ),
        // Code Text Field
        Expanded(
          flex: 2,
          child: Container(
            color: const Color(0xFF1E1E1E),
            child: TextField(
              controller: _codeController,
              maxLines: null,
              expands: true,
              style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 16, height: 1.5),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(24),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),
        // Console / Terminal
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D2B),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terminal, size: 16, color: Colors.white54),
                    const SizedBox(width: 8),
                    Text('TERMINAL', style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const Spacer(),
                    IconButton(onPressed: () => setState(() => _terminalOutput = '> Console cleared.'), icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white24, size: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _terminalOutput,
                      style: GoogleFonts.jetBrainsMono(color: Colors.greenAccent, fontSize: 14, height: 1.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sidebarLessonTile(int i, Map<String, dynamic> lesson, bool isActive, bool isDone, Color color) {
    return InkWell(
      onTap: () => setState(() => _activeLessonIndex = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        color: isActive ? color.withOpacity(0.05) : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isDone ? Colors.green : (isActive ? color : Colors.grey[300]!)),
                color: isDone ? Colors.green : (isActive ? color.withOpacity(0.1) : Colors.transparent),
              ),
              child: Center(child: Icon(isDone ? Icons.check : (isActive ? Icons.play_arrow : null), size: 14, color: isDone ? Colors.white : color)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson['title'], style: GoogleFonts.outfit(fontSize: 14, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? const Color(0xFF0D0D2B) : Colors.grey[600])),
                  Text(lesson['type'].toUpperCase(), style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey[400], letterSpacing: 1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resourceChip(String text, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading $text...'), backgroundColor: color));
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, size: 16, color: color),
            const SizedBox(width: 8),
            Text(text, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0D0D2B))),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(String label, IconData icon, VoidCallback onTap, {bool isForward = false}) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: isForward ? const SizedBox() : Icon(icon, size: 18),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isForward) ...[const SizedBox(width: 8), Icon(icon, size: 18)],
        ],
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0D0D2B),
        padding: const EdgeInsets.symmetric(vertical: 20),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
