import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../providers/auth_provider.dart';
import 'class_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EnrollmentFormScreen extends StatefulWidget {
  final String className;
  final double price;

  const EnrollmentFormScreen({super.key, required this.className, required this.price});

  @override
  State<EnrollmentFormScreen> createState() => _EnrollmentFormScreenState();
}

class _EnrollmentFormScreenState extends State<EnrollmentFormScreen> {
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String _experience = 'Beginner';
  String _paymentMethod = 'ABA Bank';
  bool _isLoading = false;

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111130),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: Color(0xFF00C9A7), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text('Enrollment Successful!', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Welcome to ${widget.className}. Your learning journey starts now.', textAlign: TextAlign.center, style: GoogleFonts.outfit(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassViewScreen(className: widget.className)));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Enter Classroom', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    if (_phoneController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${auth.baseUrl}/enroll'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': auth.user!.id,
          'className': widget.className,
          'phone': _phoneController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'experience': _experience,
          'amount': widget.price,
          'paymentMethod': _paymentMethod,
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 201) {
        if (mounted) _showSuccess();
      } else {
        throw 'Server error';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not process payment. Try again shortly. Error: $e'), backgroundColor: Colors.redAccent)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF0D0D2B),
          appBar: AppBar(title: Text('Enrollment Form'), backgroundColor: Colors.transparent, elevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Secure Registration', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('You are enrolling in ${widget.className}', style: GoogleFonts.outfit(color: Colors.white60)),
                const SizedBox(height: 32),
                _label('PHONE NUMBER'),
                _field(_phoneController, '012 345 678', Icons.phone),
                const SizedBox(height: 20),
                _label('YOUR AGE'),
                _field(_ageController, '18', Icons.cake, keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                _label('EXPERIENCE LEVEL'),
                _dropdown<String>(['Beginner', 'Intermediate', 'Advanced'], _experience, (v) => setState(() => _experience = v!)),
                const SizedBox(height: 40),
                Text('Payment Details', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(color: Colors.white60)),
                          Text('\$${widget.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                      const Divider(height: 40, color: Colors.white10),
                      _label('PAYMENT METHOD'),
                      _dropdown<String>(['ABA Bank', 'Wing', 'Credit Card'], _paymentMethod, (v) => setState(() => _paymentMethod = v!)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C9A7), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: Text(_isLoading ? 'Processing...' : 'Confirm & Pay Now', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator(color: Color(0xFF00C9A7))),
          ),
      ],
    );
  }

  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(text, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)));

  Widget _field(TextEditingController c, String h, IconData i, {TextInputType? keyboardType}) => TextField(
    controller: c, keyboardType: keyboardType, style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(prefixIcon: Icon(i, size: 18, color: Colors.white38), hintText: h, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
  );

  Widget _dropdown<T>(List<T> items, T value, ValueChanged<T?> onChanged) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.toString(), style: const TextStyle(color: Colors.white)))).toList(),
        onChanged: onChanged, dropdownColor: const Color(0xFF111130), isExpanded: true,
      ),
    ),
  );
}
