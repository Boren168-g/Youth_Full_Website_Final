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
      } catch (e) {}
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
      'month': 'SEP', 'day': '15', 'title': 'Phnom Penh Tech Summit', 'type': 'Conference',
      'location': 'Factory Phnom Penh', 'time': '8:30 AM – 4:30 PM', 'color': const Color(0xFFFF6B35),
      'desc': 'Join local developers and startups for a day of workshops and networking.', 'spots': 'Limited seats',
    },
    {
      'month': 'OCT', 'day': '05', 'title': 'Siem Reap Bootcamp', 'type': 'Workshop',
      'location': 'Heritage Hub', 'time': '1:00 PM – 5:00 PM', 'color': const Color(0xFF1E3FCE),
      'desc': 'Hands-on intensive session for beginners near the temples.', 'spots': '20 spots left',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D2B),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UPCOMING', style: GoogleFonts.outfit(color: const Color(0xFFFF6B35), fontWeight: FontWeight.bold, letterSpacing: 2)),
                      const SizedBox(height: 8),
                      Text('Events in Cambodia', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _showFullCalendar,
                    icon: const Icon(LucideIcons.calendar, size: 18),
                    label: const Text('View Full Calendar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.05),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100), side: const BorderSide(color: Colors.white10)),
                    ),
                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 3.seconds),
                ],
              ),
              const SizedBox(height: 48),
              ...events.map((ev) => _EventCard(event: ev, isBooked: _bookingStatus[ev['title']] ?? false, onTap: () {})),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool isBooked;
  final VoidCallback onTap;
  const _EventCard({required this.event, required this.isBooked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = event['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(event['day'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Text(event['location'], style: const TextStyle(color: Colors.white38, fontSize: 13)),
            ]),
          ),
          Icon(LucideIcons.chevronRight, color: color.withOpacity(0.5)),
        ],
      ),
    );
  }
}
