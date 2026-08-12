import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../providers/auth_provider.dart';
import 'class_view.dart';

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
          'age': int.parse(_ageController.text),
          'experience': _experience,
          'amount': widget.price,
          'paymentMethod': _paymentMethod,
        }),
      ).timeout(const Duration(seconds: 60)); // Added timeout

      if (response.statusCode == 201) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClassViewScreen(className: widget.className)),
          );
        }
      } else {
        final data = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${data['message'] ?? 'Enrollment failed'}'))
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection timeout or error. The cloud server might be busy.'))
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(title: Text('Enroll: ${widget.className}'), backgroundColor: Colors.transparent, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Complete Registration', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Please provide your details to start learning.', style: GoogleFonts.outfit(color: Colors.white60)),
            const SizedBox(height: 32),
            _label('PHONE NUMBER'),
            _field(_phoneController, '012 345 678', keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            _label('YOUR AGE'),
            _field(_ageController, '18', keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _label('EXPERIENCE LEVEL'),
            _dropdown<String>(['Beginner', 'Intermediate', 'Advanced'], _experience, (v) => setState(() => _experience = v!)),
            const SizedBox(height: 40),
            Text('Payment Process', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Course Fee', style: TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
                      ),
                      Text('\$${widget.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))
                    ],
                  ),
                  const Divider(height: 32, color: Colors.white10),
                  _label('SELECT PAYMENT METHOD'),
                  _dropdown<String>(['ABA Bank', 'Wing', 'Credit Card'], _paymentMethod, (v) => setState(() => _paymentMethod = v!)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C9A7), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirm & Pay Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)));
  
  Widget _field(TextEditingController c, String h, {TextInputType? keyboardType}) => TextField(
    controller: c, keyboardType: keyboardType, style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
  );

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
}
