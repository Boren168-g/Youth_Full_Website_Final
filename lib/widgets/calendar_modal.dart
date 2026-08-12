import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CalendarModal extends StatelessWidget {
  const CalendarModal({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    final schedule = [
      {
        'month': 'September 2024',
        'events': [
          {'day': '15', 'time': '08:30 AM', 'title': 'Phnom Penh Tech Summit', 'type': 'Conference', 'location': 'Factory Phnom Penh', 'color': const Color(0xFFFF6B35)},
        ]
      },
      {
        'month': 'October 2024',
        'events': [
          {'day': '05', 'time': '01:00 PM', 'title': 'Siem Reap Bootcamp', 'type': 'Workshop', 'location': 'Heritage Hub', 'color': const Color(0xFF1E3FCE)},
          {'day': '22', 'time': '07:00 PM', 'title': 'Khmer AI & Data Night', 'type': 'Virtual', 'location': 'Zoom / FB Live', 'color': const Color(0xFF00C9A7)},
        ]
      },
      {
        'month': 'November 2024',
        'events': [
          {'day': '12', 'time': '09:00 AM', 'title': 'Battambang Hackathon', 'type': 'Competition', 'location': 'Uni. Battambang', 'color': const Color(0xFFFFD23F)},
        ]
      },
      {
        'month': 'December 2024',
        'events': [
          {'day': '15', 'time': '02:00 PM', 'title': 'Year End Showcase', 'type': 'Exhibition', 'location': 'Phnom Penh Hotel', 'color': const Color(0xFF6B35FF)},
        ]
      },
      {
        'month': 'January 2025',
        'events': [
          {'day': '10', 'time': '09:00 AM', 'title': 'New Cohort Launch', 'type': 'Launch', 'location': 'C4Y Center', 'color': const Color(0xFFFF3F6B)},
        ]
      },
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24, 
        vertical: isMobile ? 16 : 40
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 950,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D2B),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withAlpha(20)),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(150), blurRadius: 50, offset: const Offset(0, 25))
            ],
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(context, isMobile),

              // Schedule List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final monthData = schedule[index];
                    return _buildMonthSection(monthData, isMobile);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACADEMIC SCHEDULE',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFFF6B35),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Event Calendar 2024-25',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 24 : 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: Colors.white38, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(15),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(Map<String, dynamic> monthData, bool isMobile) {
    final List events = monthData['events'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            children: [
              Text(
                monthData['month'].toString().toUpperCase(),
                style: GoogleFonts.outfit(
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Container(height: 1, color: Colors.white.withAlpha(10))),
            ],
          ),
        ),
        ...events.map((ev) => _buildScheduleCard(ev, isMobile)).toList(),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildScheduleCard(Map<String, dynamic> ev, bool isMobile) {
    final color = ev['color'] as Color;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time & Day
          SizedBox(
            width: isMobile ? 60 : 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ev['day'],
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  ev['time'],
                  style: GoogleFonts.outfit(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 2,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ev['title'],
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!isMobile)
                      _typeBadge(ev['type'], color),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 14, color: Colors.white38),
                    const SizedBox(width: 8),
                    Text(
                      ev['location'],
                      style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
                    ),
                  ],
                ),
                if (isMobile) ...[
                  const SizedBox(height: 12),
                  _typeBadge(ev['type'], color),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeBadge(String type, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        type.toUpperCase(),
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
