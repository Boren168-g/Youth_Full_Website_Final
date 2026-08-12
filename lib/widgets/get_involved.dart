import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GetInvolvedSection extends StatelessWidget {
  final VoidCallback? onApplyTap;
  const GetInvolvedSection({super.key, this.onApplyTap});

  @override
  Widget build(BuildContext context) {
    final ways = [
      {
        'icon': LucideIcons.bookOpen,
        'title': 'Enroll Your Child',
        'desc': "Our programs are free for students aged 10–18. Apply online and we'll match them to the right track.",
        'cta': 'Apply Now',
        'color': const Color(0xFFFF6B35),
        'bg': const Color(0xFFFFF3EE),
      },
      {
        'icon': LucideIcons.code2,
        'title': 'Volunteer',
        'desc': 'Got a tech background? Become a mentor, guest speaker, or curriculum reviewer. 2–5 hrs/week.',
        'cta': 'Volunteer',
        'color': const Color(0xFF1E3FCE),
        'bg': const Color(0xFFEEF1FF),
      },
      {
        'icon': LucideIcons.heart,
        'title': 'Donate',
        'desc': '\$50 covers one student\'s materials. \$500 funds a full scholarship. Every dollar goes directly to programs.',
        'cta': 'Give Now',
        'color': const Color(0xFF00C9A7),
        'bg': const Color(0xFFE6FAF7),
      },
      {
        'icon': LucideIcons.users,
        'title': 'Partner With Us',
        'desc': 'Companies can sponsor cohorts, offer internships, and build pipelines of diverse early-career talent.',
        'cta': 'Partner',
        'color': const Color(0xFFFFD23F),
        'bg': const Color(0xFFFFFBE6),
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0D2B), Color(0xFF1A1A4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'GET INVOLVED',
                style: GoogleFonts.outfit(
                  color: const Color(0xFFFF6B35),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Four Ways to Help',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Whether you\'re a parent, engineer, donor, or company — there\'s a meaningful way for you to be part of this.',
                style: GoogleFonts.outfit(color: Colors.white54, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: ways.length,
                    itemBuilder: (context, index) {
                      final w = ways[index];
                      return _WayCard(way: w, onTap: onApplyTap);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WayCard extends StatelessWidget {
  final Map<String, dynamic> way;
  final VoidCallback? onTap;
  const _WayCard({required this.way, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: way['bg'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(way['icon'] as IconData, color: way['color'] as Color, size: 20),
          ),
          const SizedBox(height: 20),
          Text(
            way['title'] as String,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            way['desc'] as String,
            style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14, height: 1.5),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onTap ?? () {},
            icon: Text(way['cta'] as String, style: GoogleFonts.outfit(color: way['color'] as Color, fontWeight: FontWeight.bold)),
            label: Icon(LucideIcons.arrowRight, color: way['color'] as Color, size: 16),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }
}
