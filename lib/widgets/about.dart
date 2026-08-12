import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [
      {
        'icon': LucideIcons.heart,
        'title': 'Equity First',
        'body': "We believe zip code shouldn't determine a child's future in tech. All programs are 100% free for participants.",
        'color': const Color(0xFFFF6B35),
        'bg': const Color(0xFFFFF3EE),
      },
      {
        'icon': LucideIcons.zap,
        'title': 'Real Skills',
        'body': 'From Python to machine learning, our curriculum mirrors what professional engineers use every day.',
        'color': const Color(0xFF1E3FCE),
        'bg': const Color(0xFFEEF1FF),
      },
      {
        'icon': LucideIcons.globe,
        'title': 'Global Community',
        'body': 'Students join a network of 4,200+ peers, mentors, and alumni spanning 25 provinces.',
        'color': const Color(0xFF00C9A7),
        'bg': const Color(0xFFE6FAF7),
      },
    ];

    return Container(
      color: const Color(0xFFF8F7F4),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 64,
            runSpacing: 48,
            children: [
              // Left - Image
              SizedBox(
                width: MediaQuery.of(context).size.width > 1000 ? 550 : double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -32,
                      right: MediaQuery.of(context).size.width > 1000 ? -40 : 10,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Student Story', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              '"I built my first app at 13. Now I\'m studying CS at ITC."',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF0D0D2B),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '— Boren, C4Y Class of 2023',
                              style: GoogleFonts.outfit(color: Colors.black26, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right - Text
              SizedBox(
                width: MediaQuery.of(context).size.width > 1000 ? 550 : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OUR MISSION',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFFF6B35),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Closing the Tech\nOpportunity Gap',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF0D0D2B),
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Founded with a vision to empower Cambodian youth, Code for Youth provides the tools, mentorship, and community needed to thrive in the digital economy.",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF4A4A6A),
                        fontSize: 17,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ...values.map((v) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: v['bg'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(v['icon'] as IconData, color: v['color'] as Color, size: 20),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      v['title'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF0D0D2B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      v['body'] as String,
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF6B6B80),
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
