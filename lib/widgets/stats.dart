import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'value': 4200, 'suffix': '+', 'label': 'Students Taught', 'color': const Color(0xFFFF6B35)},
      {'value': 25, 'suffix': '', 'label': 'Provinces Reached', 'color': const Color(0xFF1E3FCE)},
      {'value': 92, 'suffix': '%', 'label': 'Pursue STEM Careers', 'color': const Color(0xFF00C9A7)},
      {'value': 1200, 'suffix': '+', 'label': 'Scholarships Awarded', 'color': const Color(0xFFFFD23F)},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      color: const Color(0xFF0D0D2B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth > 800 ? 2.5 : 2.0,
                ),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final s = stats[index];
                  return _StatItem(
                    target: s['value'] as int,
                    suffix: s['suffix'] as String,
                    label: s['label'] as String,
                    color: s['color'] as Color,
                  ).animate().fadeIn(delay: (index * 100).ms, duration: 600.ms).slideY(begin: 0.2);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int target;
  final String suffix;
  final String label;
  final Color color;

  const _StatItem({
    required this.target,
    required this.suffix,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: target.toDouble()),
          duration: const Duration(milliseconds: 1800),
          builder: (context, value, child) {
            return Text(
              '${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}$suffix',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            );
          },
        ).animate().shimmer(delay: 2.seconds, duration: 1500.ms),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white.withOpacity(0.5),
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
