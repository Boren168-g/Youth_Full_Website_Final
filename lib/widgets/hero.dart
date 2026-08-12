import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onExploreTap;

  const HeroSection({super.key, required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0D0D2B)),
      child: Stack(
        children: [
          // Background Grid Pattern (Restored original Custom Painter)
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: GridPainter(),
          ),

          // Dynamic Background shapes
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E3FCE).withOpacity(0.15),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .move(begin: const Offset(0, 0), end: const Offset(-20, 20), duration: 4.seconds, curve: Curves.easeInOut),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B35).withOpacity(0.08),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .move(begin: const Offset(0, 0), end: const Offset(30, -30), duration: 6.seconds, curve: Curves.easeInOut),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 80,
                  runSpacing: 48,
                  children: [
                    // Left Content
                    SizedBox(
                      width: MediaQuery.of(context).size.width > 1000 ? 550 : double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _badge().animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                          const SizedBox(height: 32),
                          _headline().animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.1),
                          const SizedBox(height: 24),
                          _subheadline().animate().fadeIn(delay: 400.ms, duration: 800.ms).slideY(begin: 0.1),
                          const SizedBox(height: 40),
                          _actions().animate().fadeIn(delay: 600.ms, duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                        ],
                      ),
                    ),
                    // Right Content (Code Card)
                    const _CodeCard().animate()
                        .fadeIn(delay: 400.ms, duration: 1.seconds)
                        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35).withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF6B35)),
          ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1.seconds),
          const SizedBox(width: 10),
          Text(
            'Applications Open — Summer 2025',
            style: GoogleFonts.outfit(
              color: const Color(0xFFFF6B35),
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headline() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 64,
          fontWeight: FontWeight.w800,
          height: 1.05,
          color: Colors.white,
          letterSpacing: -1.5,
        ),
        children: const [
          TextSpan(text: 'Every Kid\n'),
          TextSpan(text: 'Deserves to', style: TextStyle(color: Color(0xFFFF6B35))),
          TextSpan(text: '\nCode.'),
        ],
      ),
    );
  }

  Widget _subheadline() {
    return Text(
      'Code for Youth provides free, world-class coding education to students aged 10–18. No experience needed — just curiosity and a smartphone.',
      style: GoogleFonts.outfit(
        color: Colors.white.withOpacity(0.55),
        fontSize: 18,
        height: 1.6,
      ),
    );
  }

  Widget _actions() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton.icon(
          onPressed: onExploreTap,
          icon: const Icon(LucideIcons.arrowRight, size: 18),
          label: const Text('Explore Programs'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
            textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            elevation: 10,
            shadowColor: const Color(0xFFFF6B35).withOpacity(0.4),
          ),
        ).animate().shimmer(delay: 2.seconds, duration: 2.seconds),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(LucideIcons.play, size: 18),
          label: const Text('Watch Story'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
            textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CodeCard extends StatelessWidget {
  const _CodeCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 500,
          decoration: BoxDecoration(
            color: const Color(0xFF111130),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 60,
                offset: const Offset(0, 30),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Window Chrome
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Row(
                  children: [
                    _dot(Colors.redAccent),
                    const SizedBox(width: 8),
                    _dot(Colors.amberAccent),
                    const SizedBox(width: 8),
                    _dot(Colors.greenAccent),
                    const SizedBox(width: 16),
                    Text(
                      'future.py',
                      style: GoogleFonts.jetBrainsMono(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white10),
              // Code Content
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _codeLine(1, '# Your future starts here', const Color(0xFF00C9A7)),
                    _codeLine(2, 'def change_the_world():', const Color(0xFFFFD23F)),
                    _codeLine(3, '    skills = ["Python", "Web", "AI"]', Colors.white70),
                    _codeLine(4, '    for skill in skills:', Colors.white70),
                    _codeLine(5, '        learn(skill)', Colors.white),
                    _codeLine(6, '        build(something_amazing)', Colors.white),
                    _codeLine(7, '    return confidence + chance', const Color(0xFFC084FC)),
                    const SizedBox(height: 12),
                    _codeLine(9, 'change_the_world() ✨', const Color(0xFFFF6B35)),
                  ],
                ),
              ),
              // Running...
              Padding(
                padding: const EdgeInsets.only(left: 28, bottom: 28),
                child: Row(
                  children: [
                    Text(
                      '▶ Running...',
                      style: GoogleFonts.jetBrainsMono(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 2, height: 18, color: Colors.greenAccent)
                        .animate(onPlay: (c) => c.repeat())
                        .fadeOut(duration: 500.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Interactive Badge
        Positioned(
          bottom: -24,
          left: -24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD23F),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFFD23F).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.graduationCap, size: 18, color: Color(0xFF0D0D2B)),
                const SizedBox(width: 10),
                Text(
                  '312 graduates in 2024',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF0D0D2B),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .moveY(begin: 0, end: -10, duration: 2.seconds, curve: Curves.easeInOut),
        ),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }

  Widget _codeLine(int num, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$num',
              style: GoogleFonts.jetBrainsMono(color: Colors.white10, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.jetBrainsMono(color: color, fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
