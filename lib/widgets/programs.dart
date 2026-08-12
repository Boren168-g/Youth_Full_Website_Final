import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'curriculum_modal.dart';

class ProgramsSection extends StatefulWidget {
  final Function(String)? onApplyTap;
  const ProgramsSection({super.key, this.onApplyTap});

  @override
  State<ProgramsSection> createState() => _ProgramsSectionState();
}

class _ProgramsSectionState extends State<ProgramsSection> {
  int _active = 0;
  final Map<String, bool> _registrationStatus = {};

  @override
  void initState() {
    super.initState();
    _checkAllRegistrations();
  }

  void _showCurriculum() {
    showDialog(
      context: context,
      builder: (context) => const CurriculumModal(),
    );
  }

  Future<void> _checkAllRegistrations() async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) return;

    for (var prog in programs) {
      try {
        final res = await http.get(Uri.parse('${auth.baseUrl}/check-registration?userId=${auth.user!.id}&className=${prog['title']}'));
        final data = jsonDecode(res.body);
        if (mounted) setState(() => _registrationStatus[prog['title']] = data['isRegistered']);
      } catch (e) {
        debugPrint('Error checking status');
      }
    }
  }

  final List<Map<String, dynamic>> programs = [
    {
      'tag': 'Beginner',
      'tagColor': const Color(0xFF00C9A7),
      'tagBg': const Color(0xFFE6FAF7),
      'title': 'CodeStarter',
      'subtitle': 'Ages 10–13',
      'desc': 'An engaging introduction to computational thinking using Scratch, block-based coding, and beginner Python.',
      'duration': '12 weeks',
      'seats': '20 per cohort',
      'rating': '4.9',
      'topics': ['Scratch', 'Python Basics', 'Logic & Loops'],
      'accent': const Color(0xFF00C9A7),
      'img': 'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&q=80',
    },
    {
      'tag': 'Intermediate',
      'tagColor': const Color(0xFF1E3FCE),
      'tagBg': const Color(0xFFEEF1FF),
      'title': 'WebBuilders',
      'subtitle': 'Ages 13–16',
      'desc': 'Dive into HTML, CSS, and JavaScript. Students ship real websites and build interactive web applications.',
      'duration': '16 weeks',
      'seats': '18 per cohort',
      'rating': '4.8',
      'topics': ['HTML & CSS', 'JavaScript', 'React'],
      'accent': const Color(0xFF1E3FCE),
      'img': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80',
    },
    {
      'tag': 'Advanced',
      'tagColor': const Color(0xFFFF6B35),
      'tagBg': const Color(0xFFFFF3EE),
      'title': 'AI Lab',
      'subtitle': 'Ages 15–18',
      'desc': 'Explore machine learning, neural networks, and AI ethics. Seniors work with real datasets.',
      'duration': '20 weeks',
      'seats': '15 per cohort',
      'rating': '5.0',
      'topics': ['Python ML', 'TensorFlow', 'Data Science'],
      'accent': const Color(0xFFFF6B35),
      'img': 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final p = programs[_active];
    bool isMobile = MediaQuery.of(context).size.width <= 700;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WHAT WE TEACH', style: GoogleFonts.outfit(color: const Color(0xFFFF6B35), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 14)),
                        const SizedBox(height: 16),
                        Text('Three Tracks,\nInfinite Futures', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF0D0D2B), fontSize: 40, fontWeight: FontWeight.w800, height: 1.1)),
                      ],
                    ),
                  ),
                  if (!isMobile)
                    OutlinedButton.icon(
                      onPressed: _showCurriculum,
                      icon: const Icon(LucideIcons.arrowRight, size: 16),
                      label: const Text('View Full Curriculum'),
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF0D0D2B), side: const BorderSide(color: Color(0xFF0D0D2B), width: 2), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                    ),
                ],
              ),
              if (isMobile) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _showCurriculum,
                  icon: const Icon(LucideIcons.arrowRight, size: 16),
                  label: const Text('View Full Curriculum'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0D0D2B), 
                    side: const BorderSide(color: Color(0xFF0D0D2B), width: 2), 
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    minimumSize: const Size(double.infinity, 54),
                  ),
                ),
              ],
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFF8F7F4), borderRadius: BorderRadius.circular(100)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: programs.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var prog = entry.value;
                    bool isActive = _active == idx;
                    return GestureDetector(
                      onTap: () => setState(() => _active = idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(color: isActive ? prog['accent'] as Color : Colors.transparent, borderRadius: BorderRadius.circular(100)),
                        child: Text(prog['title'] as String, style: GoogleFonts.outfit(color: isActive ? Colors.white : const Color(0xFF6B6B80), fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: 500.ms,
                child: Container(
                  key: ValueKey(_active),
                  decoration: BoxDecoration(color: const Color(0xFFF8F7F4), borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFF0D0D2B).withOpacity(0.08))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Wrap(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width > 1000 ? 590 : MediaQuery.of(context).size.width - 48,
                          height: 450,
                          child: Image.network(
                            p['img'] as String, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 50, color: Colors.grey)),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width > 1000 ? 590 : MediaQuery.of(context).size.width - 48,
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['subtitle'] as String, style: GoogleFonts.outfit(color: const Color(0xFFFF6B35), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                              const SizedBox(height: 12),
                              Text(p['title'] as String, style: GoogleFonts.plusJakartaSans(color: const Color(0xFF0D0D2B), fontSize: 36, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 20),
                              Text(p['desc'] as String, style: GoogleFonts.outfit(color: const Color(0xFF4A4A6A), fontSize: 16, height: 1.7)),
                              const SizedBox(height: 32),
                              Wrap(
                                spacing: 24, runSpacing: 12,
                                children: [
                                  _metaItem(LucideIcons.clock, p['duration'] as String, p['accent']),
                                  _metaItem(LucideIcons.users, p['seats'] as String, p['accent']),
                                  _metaItem(LucideIcons.star, p['rating'] as String, const Color(0xFFFFD23F)),
                                ],
                              ),
                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => widget.onApplyTap?.call(p['title']),
                                  icon: Icon(_registrationStatus[p['title']] == true ? Icons.login : LucideIcons.arrowRight, size: 18),
                                  label: Text(_registrationStatus[p['title']] == true ? 'Enter Classroom' : 'Apply Now — It\'s Free'),
                                  style: ElevatedButton.styleFrom(backgroundColor: _registrationStatus[p['title']] == true ? const Color(0xFF0D0D2B) : p['accent'] as Color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String text, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 18, color: color), const SizedBox(width: 10), Text(text, style: GoogleFonts.outfit(color: const Color(0xFF4A4A6A), fontSize: 15, fontWeight: FontWeight.w500))]);
  }
}
