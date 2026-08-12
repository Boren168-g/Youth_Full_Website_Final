import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'event_registration_modal.dart';
import 'calendar_modal.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EventsSection extends StatefulWidget {
  const EventsSection({super.key});

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  final Map<String, bool> _bookingStatus = {};

  @override
  void initState() {
    super.initState();
    _checkAllBookings();
  }

  Future<void> _checkAllBookings() async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) return;

    for (var ev in events) {
      try {
        final res = await http.get(Uri.parse('${auth.baseUrl}/check-event-booking?userId=${auth.user!.id}&eventTitle=${ev['title']}'));
        final data = jsonDecode(res.body);
        if (mounted) setState(() => _bookingStatus[ev['title'].toString()] = data['isBooked'] ?? false);
      } catch (e) {
        debugPrint('Error checking booking for ${ev['title']}');
      }
    }
  }

  void _openRegistration(BuildContext context, Map<String, dynamic> event) async {
    final auth = context.read<AuthProvider>();
    
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in first to secure your seat.')),
      );
      return;
    }

    if (_bookingStatus[event['title']] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already booked this event!')),
      );
      return;
    }

    final success = await showDialog<bool>(
      context: context,
      builder: (context) => EventRegistrationModal(event: event),
    );

    if (success == true) {
      setState(() => _bookingStatus[event['title'].toString()] = true);
    }
  }

  void _showFullCalendar() {
    showDialog(
      context: context,
      builder: (context) => const CalendarModal(),
    );
  }

  final events = [
    {
      'month': 'SEP',
      'day': '15',
      'title': 'Phnom Penh Tech Summit',
      'type': 'Conference',
      'location': 'Factory Phnom Penh',
      'time': '8:30 AM – 4:30 PM',
      'desc': 'Join local developers and startups for a day of workshops, networking, and the future of tech in Cambodia.',
      'color': const Color(0xFFFF6B35),
      'spots': 'Limited seats',
    },
    {
      'month': 'OCT',
      'day': '05',
      'title': 'Siem Reap Coding Bootcamp',
      'type': 'Workshop',
      'location': 'Heritage Hub',
      'time': '1:00 PM – 5:00 PM',
      'desc': 'A hands-on intensive session for beginners. Learn the basics of web development near the temples.',
      'color': const Color(0xFF1E3FCE),
      'spots': '20 spots left',
    },
    {
      'month': 'OCT',
      'day': '22',
      'title': 'Khmer AI & Data Night',
      'type': 'Virtual',
      'location': 'Zoom / Facebook Live',
      'time': '7:00 PM – 9:00 PM',
      'desc': 'Exploring how Artificial Intelligence is being used in the Khmer language and local industries.',
      'color': const Color(0xFF00C9A7),
      'spots': 'Open registration',
    },
    {
      'month': 'NOV',
      'day': '12',
      'title': 'Battambang Youth Hackathon',
      'type': 'Competition',
      'location': 'University of Battambang',
      'time': '2 Days Event',
      'desc': 'Build solutions for local challenges. Teams will compete for prizes and mentorship opportunities.',
      'color': const Color(0xFFFFD23F),
      'spots': 'Team only',
    },
    {
      'month': 'DEC',
      'day': '15',
      'title': 'Year End Showcase 2024',
      'type': 'Exhibition',
      'location': 'Phnom Penh Hotel',
      'time': '2:00 PM – 6:00 PM',
      'desc': 'A celebration of student projects from the past year. Live demos and networking with industry leaders.',
      'color': const Color(0xFF6B35FF),
      'spots': 'Free Admission',
    },
    {
      'month': 'JAN',
      'day': '10',
      'title': 'New Year Cohort Launch',
      'type': 'Launch Event',
      'location': 'C4Y Innovation Center',
      'time': '9:00 AM – 11:00 AM',
      'desc': 'Welcome event for our new students and parents. Orientation and toolkit setup session.',
      'color': const Color(0xFFFF3F6B),
      'spots': 'Invite Only',
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      color: const Color(0xFF0D0D2B),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UPCOMING',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFFF6B35),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 14,
                          ),
                        ).animate().fadeIn().slideX(begin: -0.2),
                        const SizedBox(height: 16),
                        Text(
                          'Events in Cambodia',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: isMobile ? 32 : 40,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                      ],
                    ),
                  ),
                  if (!isMobile)
                    _fullCalendarBtn().animate().fadeIn(delay: 400.ms),
                ],
              ),
              if (isMobile) ...[
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: _fullCalendarBtn()),
              ],
              const SizedBox(height: 48),
              // Fixing the animation call to apply to individual children
              ...events.asMap().entries.map((entry) {
                int index = entry.key;
                var ev = entry.value;
                return _EventCard(
                  event: ev,
                  onTap: () => _openRegistration(context, ev),
                  isBooked: _bookingStatus[ev['title'].toString()] ?? false,
                ).animate(delay: (index * 100).ms).fadeIn(duration: 500.ms).slideY(begin: 0.1);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fullCalendarBtn() {
    return OutlinedButton.icon(
      onPressed: _showFullCalendar,
      icon: const Icon(LucideIcons.calendar, size: 18),
      label: const Text('View Full Calendar'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white24, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;
  final bool isBooked;
  const _EventCard({required this.event, required this.onTap, required this.isBooked});

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.event['color'] as Color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white.withAlpha(8) : Colors.white.withAlpha(3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: widget.isBooked 
                ? Colors.green.withAlpha(100) 
                : (_isHovered ? color.withAlpha(128) : Colors.white.withAlpha(13)),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: color.withAlpha(25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isMobile = constraints.maxWidth < 800;
                  
                  if (isMobile) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _dateCircle(color),
                            const SizedBox(width: 16),
                            Expanded(child: _eventBadge(color)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _infoContent(color, double.infinity),
                        const SizedBox(height: 20),
                        _ctaButton(color, alignment: CrossAxisAlignment.start),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _dateCircle(color),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _infoContent(color, null),
                      ),
                      const SizedBox(width: 24),
                      _ctaButton(color),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateCircle(Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: widget.isBooked ? Colors.green : color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (widget.isBooked ? Colors.green : color).withAlpha(77), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isBooked)
            const Icon(Icons.check, color: Colors.white, size: 32)
          else ...[
            Text(
              widget.event['month'] as String,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.event['day'] as String,
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, height: 1),
            ),
          ]
        ],
      ),
    );
  }

  Widget _eventBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: (widget.isBooked ? Colors.green : color).withAlpha(25),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        widget.isBooked ? 'CONFIRMED' : (widget.event['type'] as String),
        style: GoogleFonts.outfit(
          color: widget.isBooked ? Colors.green : color, 
          fontSize: 11, 
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _infoContent(Color color, double? width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.event['title'] as String,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              if (width == null) ...[ 
                const SizedBox(width: 8),
                _eventBadge(color),
              ]
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _metaIcon(LucideIcons.mapPin, widget.event['location'] as String, color),
              _metaIcon(LucideIcons.clock, widget.event['time'] as String, color),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.event['desc'] as String,
            style: GoogleFonts.outfit(color: Colors.white54, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _ctaButton(Color color, {CrossAxisAlignment alignment = CrossAxisAlignment.end}) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isBooked)
          Text(
            widget.event['spots'] as String,
            style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isBooked 
                ? Colors.green 
                : (_isHovered ? color : Colors.white.withAlpha(13)),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isBooked ? 'Booked' : 'Secure Seat',
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Icon(
                widget.isBooked ? Icons.check_circle : LucideIcons.arrowRight, 
                size: 16, 
                color: Colors.white
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metaIcon(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: (widget.isBooked ? Colors.green : color).withAlpha(128)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text, 
            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
