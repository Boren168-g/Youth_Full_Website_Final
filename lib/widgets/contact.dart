import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _sent = false;
  bool _isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _submit(String baseUrl) async {
    if (_nameController.text.trim().isEmpty || 
        _emailController.text.trim().isEmpty || 
        _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Basic email validation
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/contact'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'message': _messageController.text.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        setState(() {
          _sent = true;
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        });
      } else {
        throw Exception('Server returned error: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send message. Is the backend running?')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Container(
      color: const Color(0xFFF8F7F4),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            spacing: 64,
            runSpacing: 48,
            children: [
              // Left
              SizedBox(
                width: MediaQuery.of(context).size.width > 1000 ? 550 : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REACH OUT', style: GoogleFonts.outfit(color: const Color(0xFFFF6B35), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 14)),
                    const SizedBox(height: 16),
                    Text('Let\'s Talk', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF0D0D2B), fontSize: 40, fontWeight: FontWeight.w800, height: 1.1)),
                    const SizedBox(height: 24),
                    Text('Questions about programs, volunteering, partnerships, or anything else — we reply within 48 hours.', style: GoogleFonts.outfit(color: const Color(0xFF4A4A6A), fontSize: 17, height: 1.6)),
                    const SizedBox(height: 40),
                    _infoItem(LucideIcons.mail, 'hello@codeforyouth.org.kh'),
                    _infoItem(LucideIcons.phone, '+855 23 888 123'),
                    _infoItem(LucideIcons.mapPin, 'No. 123, St. 456, Sangkat Boeung Keng Kang I, Phnom Penh, Cambodia'),
                  ],
                ),
              ),
              // Right - Form
              Container(
                width: MediaQuery.of(context).size.width > 1000 ? 550 : double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [BoxShadow(color: const Color(0xFF0D0D2B).withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 4))],
                ),
                child: _sent ? _successMessage() : _contactForm(auth.baseUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: const Color(0xFFFFF3EE), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFFFF6B35), size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: GoogleFonts.outfit(color: const Color(0xFF4A4A6A), fontSize: 14))),
        ],
      ),
    );
  }

  Widget _successMessage() {
    return Column(
      children: [
        const Icon(LucideIcons.checkCircle, color: Color(0xFF00C9A7), size: 64),
        const SizedBox(height: 24),
        Text('Message Sent!', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () => setState(() => _sent = false), child: const Text('Send another'))
      ],
    );
  }

  Widget _contactForm(String baseUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('NAME'), _field(_nameController, 'Your name'),
        const SizedBox(height: 20),
        _label('EMAIL'), _field(_emailController, 'Your email'),
        const SizedBox(height: 20),
        _label('MESSAGE'), _field(_messageController, 'Your message', maxLines: 4),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _submit(baseUrl),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Send Message'),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)));
  Widget _field(TextEditingController c, String h, {int maxLines = 1}) => TextField(controller: c, maxLines: maxLines, style: const TextStyle(color: Color(0xFF0D0D2B)), decoration: InputDecoration(hintText: h, filled: true, fillColor: const Color(0xFFF8F7F4), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)));
}
