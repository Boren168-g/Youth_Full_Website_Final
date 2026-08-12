import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  int _idx = 0;

  final List<Map<String, dynamic>> testimonials = [
    {
      'name': 'Chamroeun Boren',
      'role': 'C4Y Alumni, 2023',
      'body': "Code for Youth changed everything for me. I grew up in a neighborhood where nobody talked about tech careers. Now I'm on a full scholarship at ITC.",
      'initials': 'CB',
      'color': const Color(0xFFFF6B35),
    },
    {
      'name': 'Heng Sunthora',
      'role': 'Parent of student',
      'body': "Both my kids are in the program and the change in their confidence is unbelievable. My 14-year-old already has her first freelance client.",
      'initials': 'HS',
      'color': const Color(0xFF1E3FCE),
    },
    {
      'name': 'Neang Kimleap',
      'role': 'C4Y Alumni, 2021',
      'body': "The AI Lab program taught me how to learn, not just what to learn. That mindset shift is what helped me co-found a local startup.",
      'initials': 'NK',
      'color': const Color(0xFF00C9A7),
    },
    {
      'name': 'Nhor Nhean',
      'role': 'Volunteer Instructor',
      'body': "Teaching here is rewarding. These kids are sharp and creative. All they needed was an open door. Code for Youth is that door.",
      'initials': 'NN',
      'color': const Color(0xFFFFD23F),
    },
    {
      'name': 'Ou Piseth',
      'role': 'Senior Mentor',
      'body': "Guiding the next generation through Code for Youth has been an incredible experience. Seeing their growth drives our mission forward.",
      'initials': 'OP',
      'color': const Color(0xFF6B35FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final t = testimonials[_idx];

    return Container(
      color: const Color(0xFF0D0D2B),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Text('STORIES', style: GoogleFonts.outfit(color: const Color(0xFFFF6B35), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 14)).animate().fadeIn().slideY(begin: -0.2),
              const SizedBox(height: 16),
              Text('The Real Impact', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, height: 1.1)).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              const SizedBox(height: 64),
              AnimatedSwitcher(
                duration: 500.ms,
                child: Container(
                  key: ValueKey(_idx),
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(color: const Color(0xFF111130), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white.withOpacity(0.06))),
                  child: Column(
                    children: [
                      Icon(LucideIcons.quote, size: 48, color: (t['color'] as Color).withOpacity(0.4)).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 0, end: -8, duration: 1500.ms),
                      const SizedBox(height: 32),
                      Text('"${t['body']}"', style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.9), fontSize: 22, height: 1.6), textAlign: TextAlign.center),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(color: t['color'] as Color, shape: BoxShape.circle),
                            child: Center(child: Text(t['initials'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                          ),
                          const SizedBox(width: 20),
                          Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t['name'] as String, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis), Text(t['role'] as String, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 13), overflow: TextOverflow.ellipsis, maxLines: 2)])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _btn(LucideIcons.chevronLeft, () => setState(() => _idx = (_idx - 1 + testimonials.length) % testimonials.length)),
                  const SizedBox(width: 24),
                  Row(children: testimonials.asMap().entries.map((e) => GestureDetector(onTap: () => setState(() => _idx = e.key), child: AnimatedContainer(duration: 300.ms, margin: const EdgeInsets.symmetric(horizontal: 6), width: e.key == _idx ? 32 : 10, height: 10, decoration: BoxDecoration(color: e.key == _idx ? (t['color'] as Color) : Colors.white10, borderRadius: BorderRadius.circular(100))))).toList()),
                  const SizedBox(width: 24),
                  _btn(LucideIcons.chevronRight, () => setState(() => _idx = (_idx + 1) % testimonials.length)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(IconData i, VoidCallback o) => Material(color: Colors.transparent, child: InkWell(onTap: o, borderRadius: BorderRadius.circular(100), child: Container(width: 52, height: 52, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.15))), child: Icon(i, size: 20, color: Colors.white))));
}
