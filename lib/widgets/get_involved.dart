import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';

class GetInvolvedSection extends StatelessWidget {
  const GetInvolvedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ways = [
      {
        'icon': LucideIcons.bookOpen,
        'title': 'Enroll Your Child',
        'desc': "Our programs are free for students aged 10–18. Join a cohort and start the journey.",
        'cta': 'Enroll Now',
        'color': const Color(0xFFFF6B35),
        'type': 'enrollment',
      },
      {
        'icon': LucideIcons.code2,
        'title': 'Volunteer',
        'desc': 'Got a tech background? Become a mentor or guest speaker. Share your expertise.',
        'cta': 'Join Team',
        'color': const Color(0xFF1E3FCE),
        'type': 'volunteer',
      },
      {
        'icon': LucideIcons.heart,
        'title': 'Donate',
        'desc': '\$50 covers materials for one student. Every contribution makes a difference.',
        'cta': 'Give Today',
        'color': const Color(0xFF00C9A7),
        'type': 'donation',
      },
      {
        'icon': LucideIcons.users,
        'title': 'Partner With Us',
        'desc': 'Sponsor a cohort or offer internships. Build a pipeline for diverse talent.',
        'cta': 'Become Partner',
        'color': const Color(0xFFFFD23F),
        'type': 'partnership',
      },
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D2B),
      ),
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'GET INVOLVED',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFFF6B35),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      fontSize: 12,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 20),
                  Text(
                    'Four Ways to Help',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: 20),
                  SizedBox(
                    maxWidth: 600,
                    child: Text(
                      'Impact the next generation of Cambodian developers. Choose the path that matches your passion.',
                      style: GoogleFonts.outfit(color: Colors.white.withAlpha(120), fontSize: 18, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
              const SizedBox(height: 80),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 1100 ? 4 : (constraints.maxWidth > 650 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      mainAxisExtent: 340,
                    ),
                    itemCount: ways.length,
                    itemBuilder: (context, index) {
                      return _WayCard(way: ways[index], index: index);
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

class _WayCard extends StatefulWidget {
  final Map<String, dynamic> way;
  final int index;
  const _WayCard({required this.way, required this.index});

  @override
  State<_WayCard> createState() => _WayCardState();
}

class _WayCardState extends State<_WayCard> {
  bool _isHovered = false;

  void _openInvolvementModal(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to register your interest.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _InvolvementModal(way: widget.way),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.way['color'] as Color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _openInvolvementModal(context),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withAlpha(10) : Colors.white.withAlpha(4),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _isHovered ? color.withAlpha(100) : Colors.white.withAlpha(10),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(widget.way['icon'] as IconData, color: color, size: 28),
              ),
              const SizedBox(height: 28),
              Text(
                widget.way['title'] as String,
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                widget.way['desc'] as String,
                style: GoogleFonts.outfit(color: Colors.white.withAlpha(100), fontSize: 14, height: 1.6),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    widget.way['cta'] as String,
                    style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Icon(LucideIcons.arrowRight, color: color, size: 16),
                ],
              ),
            ],
          ),
        ),
      ).animate(delay: (widget.index * 100).ms).fadeIn().slideY(begin: 0.1),
    );
  }
}

class _InvolvementModal extends StatefulWidget {
  final Map<String, dynamic> way;
  const _InvolvementModal({required this.way});

  @override
  State<_InvolvementModal> createState() => _InvolvementModalState();
}

class _InvolvementModalState extends State<_InvolvementModal> {
  final _noteController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    if (_noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a short note.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${auth.baseUrl}/get-involved-submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': auth.user!.id,
          'type': widget.way['type'],
          'note': _noteController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you! We will contact you soon.'), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submission failed.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.way['color'] as Color;
    return Dialog(
      backgroundColor: const Color(0xFF111130),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28), side: BorderSide(color: color.withAlpha(50))),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Register Interest', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Way to help: ${widget.way['title']}', style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a message or your details...',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withAlpha(5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
