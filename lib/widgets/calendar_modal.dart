import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CalendarModal extends StatelessWidget {
  const CalendarModal({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    final events = [
      {'date': '15 SEP', 'title': 'Phnom Penh Tech Summit', 'type': 'Conference', 'location': 'Factory Phnom Penh', 'color': const Color(0xFFFF6B35)},
      {'date': '05 OCT', 'title': 'Siem Reap Bootcamp', 'type': 'Workshop', 'location': 'Heritage Hub', 'color': const Color(0xFF1E3FCE)},
      {'date': '22 OCT', 'title': 'Khmer AI & Data Night', 'type': 'Virtual', 'location': 'Zoom / FB Live', 'color': const Color(0xFF00C9A7)},
      {'date': '12 NOV', 'title': 'Battambang Hackathon', 'type': 'Competition', 'location': 'Uni. Battambang', 'color': const Color(0xFFFFD23F)},
      {'date': '15 DEC', 'title': 'Year End Showcase', 'type': 'Exhibition', 'location': 'Phnom Penh Hotel', 'color': const Color(0xFF6B35FF)},
      {'date': '10 JAN', 'title': 'New Cohort Launch', 'type': 'Launch', 'location': 'C4Y Center', 'color': const Color(0xFFFF3F6B)},
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24, 
        vertical: isMobile ? 16 : 40
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D2B),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 20))
            ],
          ),
          child: Column(
            children: [
              // Custom Top Header
              Container(
                padding: const EdgeInsets.fromLTRB(32, 32, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  '2024-2025 SEASON',
                                  style: GoogleFonts.outfit(color: const Color(0xFFFF6B35), fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Event Calendar',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isMobile ? 26 : 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x, color: Colors.white38, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.05),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),

              // Calendar Body
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final ev = events[index];
                    final color = ev['color'] as Color;
                    
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                            // Date Column
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ev['date']!.split(' ')[1],
                                    style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ev['date']!.split(' ')[0],
                                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Details Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ev['title']!,
                                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(LucideIcons.mapPin, size: 12, color: color.withOpacity(0.7)),
                                      const SizedBox(width: 6),
                                      Text(
                                        ev['location']!,
                                        style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(
                                        width: 4, height: 4,
                                        decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        ev['type']!,
                                        style: GoogleFonts.outfit(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!isMobile)
                              const Icon(LucideIcons.chevronRight, color: Colors.white10),
                          ],
                        ),
                      ),
                    ).animate(delay: (index * 80).ms).fadeIn(duration: 400.ms).slideX(begin: 0.05);
                  },
                ),
              ),
              
              // Bottom Footer
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.01),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Center(
                  child: Text(
                    'More events being added soon. Stay tuned!',
                    style: GoogleFonts.outfit(color: Colors.white24, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
