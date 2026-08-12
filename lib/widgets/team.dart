import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final team = [
      {
        'name': 'Dr. Keisha Monroe',
        'role': 'Executive Director',
        'bio': 'Former Google engineer and education policy advocate. 15 years building equitable tech pathways.',
        'color': const Color(0xFFFF6B35),
        'img': 'https://images.unsplash.com/photo-1596496356933-9b6e0b186b88?w=400&h=400&fit=crop&auto=format&faces=1',
      },
      {
        'name': 'Marcus Chen',
        'role': 'Director of Curriculum',
        'bio': 'Ex-Meta engineer. Designed learning experiences for 10,000+ developers worldwide before joining C4Y.',
        'color': const Color(0xFF1E3FCE),
        'img': 'https://images.unsplash.com/photo-1571391756721-0e5caf1d8f80?w=400&h=400&fit=crop&auto=format',
      },
      {
        'name': 'Zara Ahmed',
        'role': 'Head of Community',
        'bio': "Youth organizer turned nonprofit leader. Built C4Y's alumni network to over 2,000 members.",
        'color': const Color(0xFF00C9A7),
        'img': 'https://images.unsplash.com/photo-1705579610984-910ad33fe2db?w=400&h=400&fit=crop&auto=format',
      },
      {
        'name': 'Leo Okonkwo',
        'role': 'Lead Instructor, AI Lab',
        'bio': 'PhD candidate in Machine Learning at MIT. Was a C4Y student himself — and now gives back full-time.',
        'color': const Color(0xFFFFD23F),
        'img': 'https://images.unsplash.com/photo-1705579610258-215a3e0025aa?w=400&h=400&fit=crop&auto=format',
      },
    ];

    return Container(
      color: const Color(0xFFF8F7F4),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WHO WE ARE',
                style: GoogleFonts.outfit(
                  color: const Color(0xFFFF6B35),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
              const SizedBox(height: 16),
              Text(
                'Meet the Team',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF0D0D2B),
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.1),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: constraints.maxWidth > 600 ? 0.72 : 1.1,
                    ),
                    itemCount: team.length,
                    itemBuilder: (context, index) {
                      final member = team[index];
                      return _MemberCard(member: member)
                        .animate(delay: (200 + (index * 100)).ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.2, curve: Curves.easeOutQuad);
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

class _MemberCard extends StatefulWidget {
  final Map<String, dynamic> member;
  const _MemberCard({required this.member});

  @override
  State<_MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<_MemberCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.member['color'] as Color;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeOutCubic,
        transform: _isHovered ? (Matrix4.identity()..translate(0, -12, 0)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? color.withOpacity(0.5) : const Color(0xFF0D0D2B).withOpacity(0.06),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? color.withOpacity(0.15) : const Color(0xFF0D0D2B).withOpacity(0.04),
              blurRadius: _isHovered ? 24 : 12,
              offset: Offset(0, _isHovered ? 12 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.member['img'] as String, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: 300.ms,
                      opacity: _isHovered ? 1.0 : 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              color.withOpacity(0.7),
                            ],
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'View Profile',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(height: 4, color: color),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.member['name'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF0D0D2B),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.member['role'] as String,
                        style: GoogleFonts.outfit(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Text(
                          widget.member['bio'] as String,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF6B6B80),
                            fontSize: 13,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _socialIcon(FontAwesomeIcons.linkedinIn, color),
                          const SizedBox(width: 10),
                          _socialIcon(FontAwesomeIcons.twitter, color),
                          const Spacer(),
                          Icon(Icons.arrow_forward_rounded, 
                            size: 18, 
                            color: _isHovered ? color : Colors.transparent
                          ).animate(target: _isHovered ? 1 : 0).fadeIn().slideX(begin: -0.5),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color brandColor) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: FaIcon(
          icon, 
          size: 14, 
          color: const Color(0xFF0D0D2B).withOpacity(0.6)
        ),
      ),
    );
  }
}
