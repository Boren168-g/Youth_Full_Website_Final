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
      {'date': '15 SEP', 'title': 'Phnom Penh Tech Summit', 'type': 'Conference', 'color': const Color(0xFFFF6B35)},
      {'date': '05 OCT', 'title': 'Siem Reap Bootcamp', 'type': 'Workshop', 'color': const Color(0xFF1E3FCE)},
      {'date': '22 OCT', 'title': 'Khmer AI & Data Night', 'type': 'Virtual', 'color': const Color(0xFF00C9A7)},
      {'date': '12 NOV', 'title': 'Battambang Hackathon', 'type': 'Competition', 'color': const Color(0xFFFFD23F)},
      {'date': '15 DEC', 'title': 'Year End Showcase', 'type': 'Exhibition', 'color': const Color(0xFF6B35FF)},
      {'date': '10 JAN', 'title': 'New Cohort Launch', 'type': 'Launch', 'color': const Color(0xFFFF3F6B)},
    ];

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
          maxWidth: 900,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EVENT CALENDAR',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFFF6B35),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upcoming Schedule',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, color: Colors.white38),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Calendar List
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final ev = events[index];
                    final color = ev['color'] as Color;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ev['date']!.split(' ')[1],
                                  style: GoogleFonts.outfit(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ev['date']!.split(' ')[0],
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ev['title']!,
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ev['type']!,
                                  style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          if (!isMobile)
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Add to Google Calendar'),
                            ),
                        ],
                      ),
                    ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
