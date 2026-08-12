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
          {'day': '15', 'time': '08:30 AM', 'title': 'Phnom Penh Tech Summit', 'type': 'Conference', 'location': 'Factory Phnom Penh', 'color': const Color(0xFFFF6B35), 'status': 'Registration Open'},
        ]
      },
      {
        'month': 'October 2024',
        'events': [
          {'day': '05', 'time': '01:00 PM', 'title': 'Siem Reap Bootcamp', 'type': 'Workshop', 'location': 'Heritage Hub', 'color': const Color(0xFF1E3FCE), 'status': 'Limited Spots'},
          {'day': '22', 'time': '07:00 PM', 'title': 'Khmer AI & Data Night', 'type': 'Virtual', 'location': 'Zoom / FB Live', 'color': const Color(0xFF00C9A7), 'status': 'Free Entry'},
        ]
      },
      {
        'month': 'November 2024',
        'events': [
          {'day': '12', 'time': '09:00 AM', 'title': 'Battambang Hackathon', 'type': 'Competition', 'location': 'Uni. Battambang', 'color': const Color(0xFFFFD23F), 'status': 'Applications Open'},
        ]
      },
      {
        'month': 'December 2024',
        'events': [
          {'day': '15', 'time': '02:00 PM', 'title': 'Year End Showcase', 'type': 'Exhibition', 'location': 'Phnom Penh Hotel', 'color': const Color(0xFF6B35FF), 'status': 'Coming Soon'},
        ]
      },
      {
        'month': 'January 2025',
        'events': [
          {'day': '10', 'time': '09:00 AM', 'title': 'New Cohort Launch', 'type': 'Launch', 'location': 'C4Y Center', 'color': const Color(0xFFFF3F6B), 'status': 'Invite Only'},
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
          maxWidth: 1000,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D2B),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withAlpha(20)),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(180), blurRadius: 60, offset: const Offset(0, 30))
            ],
          ),
          child: Column(
            children: [
              // Dynamic Header
              _buildHeader(context, isMobile),

              // Scrollable Schedule
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(40, 24, 40, 40),
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final monthData = schedule[index];
                    return _buildMonthSection(monthData, isMobile, index);
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
      padding: const EdgeInsets.fromLTRB(40, 40, 32, 40),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(bottom: BorderSide(color: Colors.white.withAlpha(10))),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF6B35).withAlpha(100), blurRadius: 20)
              ],
            ),
            child: const Icon(LucideIcons.calendarDays, color: Colors.white, size: 28),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ACADEMIC YEAR 2024-25',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFFF6B35),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24)),
                    const SizedBox(width: 12),
                    Text(
                      '5 MONTHS PLANNED',
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Interactive Schedule',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 28 : 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: Colors.white38, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(15),
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(Map<String, dynamic> monthData, bool isMobile, int monthIndex) {
    final List events = monthData['events'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  monthData['month'].toString().toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: Container(height: 1, color: Colors.white.withAlpha(10))),
            ],
          ),
        ),
        ...events.asMap().entries.map((entry) {
          return _buildScheduleItem(entry.value, isMobile, entry.key == events.length - 1);
        }).toList(),
      ],
    ).animate(delay: (monthIndex * 150).ms).fadeIn(duration: 500.ms).slideX(begin: 0.05);
  }

  Widget _buildScheduleItem(Map<String, dynamic> ev, bool isMobile, bool isLastInMonth) {
    final color = ev['color'] as Color;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Column
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0D2B),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4),
                  boxShadow: [
                    BoxShadow(color: color.withAlpha(100), blurRadius: 10)
                  ],
                ),
              ),
              if (!isLastInMonth)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color.withAlpha(30),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          
          // Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _ScheduleCard(ev: ev, isMobile: isMobile, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatefulWidget {
  final Map<String, dynamic> ev;
  final bool isMobile;
  final Color color;
  const _ScheduleCard({required this.ev, required this.isMobile, required this.color});

  @override
  State<_ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<_ScheduleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white.withAlpha(8) : Colors.white.withAlpha(3),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isHovered ? widget.color.withAlpha(80) : Colors.white.withAlpha(10),
            width: 1.5,
          ),
          boxShadow: _isHovered ? [
            BoxShadow(color: widget.color.withAlpha(15), blurRadius: 30, offset: const Offset(0, 10))
          ] : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date Section
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.ev['day'],
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.ev['time'],
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            
            // Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.ev['title'],
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      if (!widget.isMobile) _badge(widget.ev['status'], widget.color),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _infoTag(LucideIcons.mapPin, widget.ev['location']),
                      const SizedBox(width: 20),
                      _infoTag(LucideIcons.tag, widget.ev['type']),
                    ],
                  ),
                  if (widget.isMobile) ...[
                    const SizedBox(height: 16),
                    _badge(widget.ev['status'], widget.color),
                  ],
                ],
              ),
            ),
            
            if (!widget.isMobile)
              const Icon(LucideIcons.chevronRight, color: Colors.white10, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(color: color, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }

  Widget _infoTag(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white24),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
        ),
      ],
    );
  }
}
