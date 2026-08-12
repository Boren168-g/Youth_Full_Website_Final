import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CalendarModal extends StatelessWidget {
  const CalendarModal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 700;
    bool isTablet = size.width >= 700 && size.width < 1000;

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
          maxHeight: size.height * 0.9,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D2B),
            borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
            border: Border.all(color: Colors.white.withAlpha(20)),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(180), blurRadius: 60, offset: const Offset(0, 30))
            ],
          ),
          child: Column(
            children: [
              _buildHeader(context, isMobile),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(isMobile ? 20 : 40, 24, isMobile ? 20 : 40, 40),
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    return _buildMonthSection(schedule[index], isMobile, index);
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
      padding: EdgeInsets.fromLTRB(isMobile ? 24 : 40, isMobile ? 32 : 40, isMobile ? 16 : 32, isMobile ? 32 : 40),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(isMobile ? 24 : 32)),
        border: Border(bottom: BorderSide(color: Colors.white.withAlpha(10))),
      ),
      child: Row(
        children: [
          if (!isMobile) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFFFF6B35).withAlpha(100), blurRadius: 20)],
              ),
              child: const Icon(LucideIcons.calendarDays, color: Colors.white, size: 28),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            const SizedBox(width: 24),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACADEMIC YEAR 2024-25',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFFF6B35),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Full Schedule',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 24 : 36,
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
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          padding: const EdgeInsets.only(top: 32, bottom: 20),
          child: Row(
            children: [
              Text(
                monthData['month'].toString().toUpperCase(),
                style: GoogleFonts.outfit(
                  color: Colors.white.withAlpha(150),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Container(height: 1, color: Colors.white.withAlpha(10))),
            ],
          ),
        ),
        ...events.asMap().entries.map((entry) {
          return _buildScheduleItem(entry.value, isMobile, entry.key == events.length - 1);
        }).toList(),
      ],
    ).animate(delay: (monthIndex * 100).ms).fadeIn(duration: 400.ms);
  }

  Widget _buildScheduleItem(Map<String, dynamic> ev, bool isMobile, bool isLastInMonth) {
    final color = ev['color'] as Color;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14, height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0D2B),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 3),
                ),
              ),
              if (!isLastInMonth)
                Expanded(child: Container(width: 1.5, color: color.withAlpha(30))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
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
        padding: EdgeInsets.all(widget.isMobile ? 20 : 24),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white.withAlpha(8) : Colors.white.withAlpha(3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? widget.color.withAlpha(80) : Colors.white.withAlpha(10),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ev['title'],
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: widget.isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.ev['day']} ${widget.ev['month']?.toString().split(' ')[0] ?? ""} • ${widget.ev['time']}',
                        style: GoogleFonts.outfit(color: widget.color, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                if (!widget.isMobile) _badge(widget.ev['status'], widget.color),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16, runSpacing: 8,
              children: [
                _infoTag(LucideIcons.mapPin, widget.ev['location']),
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
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(color: color, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }

  Widget _infoTag(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white24),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
