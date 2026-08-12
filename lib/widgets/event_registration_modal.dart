import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';

class EventRegistrationModal extends StatefulWidget {
  final Map<String, dynamic> event;
  const EventRegistrationModal({super.key, required this.event});

  @override
  State<EventRegistrationModal> createState() => _EventRegistrationModalState();
}

class _EventRegistrationModalState extends State<EventRegistrationModal> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String _paymentMethod = 'ABA Bank';

  @override
  Widget build(BuildContext context) {
    final color = widget.event['color'] as Color;
    final auth = context.read<AuthProvider>();

    return Dialog(
      backgroundColor: const Color(0xFF111130),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EVENT REGISTRATION',
                            style: GoogleFonts.outfit(
                              color: color,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.event['title'],
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x, color: Colors.white38),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _infoRow(LucideIcons.mapPin, widget.event['location']),
                const SizedBox(height: 8),
                _infoRow(LucideIcons.calendar, '${widget.event['month']} ${widget.event['day']} @ ${widget.event['time']}'),
                const Divider(height: 32, color: Colors.white10),
                
                Text('Payment Details', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reservation Fee', style: TextStyle(color: Colors.white70)),
                      Text('\$5.00', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _label('SELECT PAYMENT METHOD'),
                _dropdown<String>(['ABA Bank', 'Wing', 'Credit Card'], _paymentMethod, (v) => setState(() => _paymentMethod = v!)),
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : () => _submit(auth),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Confirm & Pay', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdown<T>(List<T> items, T value, ValueChanged<T?> onChanged) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.toString(), style: const TextStyle(color: Colors.white)))).toList(),
        onChanged: onChanged, dropdownColor: const Color(0xFF111130), isExpanded: true,
      ),
    ),
  );

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white38),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _submit(AuthProvider auth) async {
    setState(() => _isSubmitting = true);
    
    try {
      final response = await http.post(
        Uri.parse('${auth.baseUrl}/book-event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': auth.user!.id,
          'eventTitle': widget.event['title'],
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Seat secured successfully!'), backgroundColor: Colors.green),
          );
        }
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to book');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
