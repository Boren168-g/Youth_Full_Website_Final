import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CurriculumModal extends StatefulWidget {
  const CurriculumModal({super.key});

  @override
  State<CurriculumModal> createState() => _CurriculumModalState();
}

class _CurriculumModalState extends State<CurriculumModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> curricula = [
    {
      'title': 'CodeStarter',
      'subtitle': 'The Foundation of Computational Thinking',
      'icon': LucideIcons.shapes,
      'color': const Color(0xFF00C9A7),
      'description': 'Perfect for beginners. We use block-based coding and visual logic to build a strong foundation before moving to text-based Python.',
      'modules': [
        {'name': 'Visual Logic & Algorithmic Thinking', 'lessons': 4, 'skills': ['Sequencing', 'Decomposition']},
        {'name': 'Control Flow: Loops & Conditions', 'lessons': 6, 'skills': ['Iteration', 'Booleans']},
        {'name': 'Introduction to Text-Based Python', 'lessons': 8, 'skills': ['Syntax', 'Variables']},
        {'name': 'Creative Capstone: Your First Game', 'lessons': 5, 'skills': ['Game Loop', 'Events']},
      ]
    },
    {
      'title': 'WebBuilders',
      'subtitle': 'Building for the Modern Web',
      'icon': LucideIcons.layout,
      'color': const Color(0xFF1E3FCE),
      'description': 'Master the languages of the web. Learn how to design and build professional, responsive websites and interactive web apps.',
      'modules': [
        {'name': 'HTML5: The Skeleton of the Web', 'lessons': 5, 'skills': ['Semantics', 'SEO']},
        {'name': 'CSS3: Advanced Layouts & Styling', 'lessons': 10, 'skills': ['Flexbox', 'Grid', 'Animations']},
        {'name': 'JavaScript: Bringing Sites to Life', 'lessons': 12, 'skills': ['DOM', 'Async/Await']},
        {'name': 'Modern UI Development with React', 'lessons': 15, 'skills': ['Components', 'Hooks', 'State']},
      ]
    },
    {
      'title': 'AI Lab',
      'subtitle': 'Intelligence, Data & the Future',
      'icon': LucideIcons.brainCircuit,
      'color': const Color(0xFFFF6B35),
      'description': 'Step into the world of Artificial Intelligence. Use Python to analyze data, build neural networks, and understand AI ethics.',
      'modules': [
        {'name': 'Data Science Fundamentals', 'lessons': 8, 'skills': ['NumPy', 'Pandas', 'Visualization']},
        {'name': 'Machine Learning: Predict & Classify', 'lessons': 10, 'skills': ['Regression', 'Decision Trees']},
        {'name': 'Deep Learning & Neural Networks', 'lessons': 12, 'skills': ['TensorFlow', 'Layers']},
        {'name': 'AI Ethics: Building Responsible Tech', 'lessons': 4, 'skills': ['Bias', 'Safety', 'Impact']},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: curricula.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Dialog(
      backgroundColor: const Color(0xFF0D0D2B),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24, 
        vertical: isMobile ? 16 : 40
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1100,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2025 LEARNING ROADMAP',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFFF6B35),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Full Curriculum',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isMobile ? 24 : 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, color: Colors.white38),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.05),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),

            // Custom TabBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: curricula[_tabController.index]['color'],
                  ),
                  onTap: (index) => setState(() {}),
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: curricula.map((c) => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(c['icon'], size: 18),
                        if (!isMobile) ...[
                          const SizedBox(width: 10),
                          Text(c['title']),
                        ],
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: curricula.map((track) => _TrackDetailView(track: track, isMobile: isMobile)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackDetailView extends StatelessWidget {
  final Map<String, dynamic> track;
  final bool isMobile;

  const _TrackDetailView({required this.track, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final Color color = track['color'];
    final List modules = track['modules'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Track Intro
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track['subtitle'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  track['description'] as String,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 48),

          Text(
            'THE LEARNING JOURNEY',
            style: GoogleFonts.outfit(
              color: Colors.white24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 24),

          // Modules Timeline
          Column(
            children: modules.asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              var module = entry.value as Map<String, dynamic>;
              bool isLast = index == modules.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline line
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ).animate(delay: (index * 100).ms).fadeIn().scale(),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: color.withOpacity(0.2),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    // Module Card
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      module['name'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${module['lessons']} Lessons',
                                      style: GoogleFonts.outfit(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: (module['skills'] as List<String>).map((skill) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    skill,
                                    style: GoogleFonts.jetBrainsMono(color: Colors.white38, fontSize: 11),
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.1),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
