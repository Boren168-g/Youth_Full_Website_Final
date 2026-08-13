import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'auth_modal.dart';
import '../screens/learning/class_view.dart';

class Navbar extends StatelessWidget {
  final bool isScrolled;
  final Function(String) onLinkTap;

  const Navbar({
    super.key,
    required this.isScrolled,
    required this.onLinkTap,
  });

  void _openAuth(BuildContext context, String tab) {
    showDialog(
      context: context,
      builder: (context) => AuthModal(defaultTab: tab),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Stack(
      children: [
        // Rainbow Gradient Line at the very top
        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.cyan,
                  Colors.blue,
                  Colors.purple,
                  Colors.pink,
                ],
              ),
            ),
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: isScrolled ? 10 : 0, sigmaY: isScrolled ? 10 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              color: isScrolled ? const Color(0xFF0D0D2B).withOpacity(0.8) : Colors.transparent,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 24 : 12, 
                vertical: 10
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    // Logo section matching the screenshot
                    InkWell(
                      onTap: () => onLinkTap('Home'),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.landmark, 
                            size: 24, 
                            color: Color(0xFF90CAF9) // Light blue matching screenshot
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Code4Youth',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFFFF59D), // Yellowish matching screenshot
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Desktop Links
                    if (MediaQuery.of(context).size.width > 900)
                      Row(
                        children: [
                          _navLink('About'),
                          _navLink('Programs'),
                          _navLink('Impact'),
                          _navLink('Team'),
                          _navLink('Events'),
                          _navLink('Contact'),
                        ].animate(interval: 50.ms).fadeIn(duration: 400.ms).slideX(begin: 0.1),
                      ),
                    if (MediaQuery.of(context).size.width > 900) const Spacer(),
                    // Auth Buttons
                    if (user == null) ...[
                      if (MediaQuery.of(context).size.width > 450)
                        TextButton(
                          onPressed: () => _openAuth(context, 'signin'),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () => _openAuth(context, 'signup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width > 600 ? 24 : 12,
                            vertical: 12
                          ),
                        ),
                        child: Text(
                          MediaQuery.of(context).size.width > 600 ? 'Sign Up Free' : 'Sign Up',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ).animate().shimmer(delay: 2.seconds, duration: 1500.ms),
                    ] else
                      _userDropdown(user, authProvider, context),

                    // Hamburger Menu for Mobile
                    if (MediaQuery.of(context).size.width <= 900) ...[
                      const SizedBox(width: 8),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(LucideIcons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => onLinkTap(label),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _userDropdown(User user, AuthProvider auth, BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 48),
      color: const Color(0xFF111130),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              Text(user.email, style: const TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 20),
        PopupMenuItem(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassViewScreen(className: 'CodeStarter')));
          },
          child: Row(
            children: [
              Icon(LucideIcons.bookOpen, size: 18, color: const Color(0xFFFF6B35).withOpacity(0.8)),
              const SizedBox(width: 12),
              const Text('My Learning', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: auth.signOut,
          child: const Row(
            children: [
              Icon(LucideIcons.logOut, size: 18, color: Colors.redAccent),
              SizedBox(width: 12),
              Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 14, color: Color(0xFFFF6B35), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Text(user.name.split(' ')[0], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronDown, size: 16, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
