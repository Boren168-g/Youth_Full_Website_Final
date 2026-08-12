import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> links = {
      'Programs': ['CodeStarter', 'WebBuilders', 'AI Lab', 'Alumni Network', 'Scholarships'],
      'Organization': ['About Us', 'Our Team', 'Impact Report', 'Partners', 'Press Kit'],
      'Get Involved': ['Enroll a Student', 'Volunteer', 'Donate', 'Corporate Sponsorship', 'Refer a Family'],
      'Resources': ['Student Portal', 'Parent FAQ', 'Curriculum Overview', 'Blog', 'Events Calendar'],
    };

    return Container(
      color: const Color(0xFF07071A),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Wrap(
                spacing: 64,
                runSpacing: 48,
                children: [
                  // Brand Col
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(color: const Color(0xFFFF6B35), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(LucideIcons.code2, size: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text('Code4Youth', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Free, world-class coding education for young people aged 10–18.',
                          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [FontAwesomeIcons.twitter, FontAwesomeIcons.instagram, FontAwesomeIcons.linkedin, FontAwesomeIcons.github, FontAwesomeIcons.youtube].map((icon) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: FaIcon(icon, size: 16, color: Colors.white24),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  // Link Cols
                  ...links.entries.map((entry) => SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key.toUpperCase(), style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 20),
                        ...entry.value.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(item, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13)),
                        )),
                      ],
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 64),
              const Divider(color: Colors.white10),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  Text('© 2025 Code for Youth. Nonprofit.', style: GoogleFonts.outfit(color: Colors.white12, fontSize: 11)),
                  Wrap(
                    spacing: 24,
                    children: ['Privacy', 'Terms', 'Accessibility'].map((item) => Text(item, style: GoogleFonts.outfit(color: Colors.white12, fontSize: 11))).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
