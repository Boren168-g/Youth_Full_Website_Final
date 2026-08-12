import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class AuthModal extends StatefulWidget {
  final String defaultTab;
  const AuthModal({super.key, this.defaultTab = 'signin'});

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  late String _tab;
  bool _showPw = false;
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _nameController = TextEditingController();
  UserRole _role = UserRole.student;

  @override
  void initState() {
    super.initState();
    _tab = widget.defaultTab;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Dialog(
      backgroundColor: const Color(0xFF111130),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withOpacity(0.06)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(color: const Color(0xFFFF6B35), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.code2, size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text('Code4Youth', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, size: 16, color: Colors.white38)),
              ],
            ),
            const SizedBox(height: 24),
            // Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: const Color(0xFF0D0D2B), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  _tabBtn('signin', 'Sign In'),
                  _tabBtn('signup', 'Create Account'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _tab == 'signin' 
                  ? 'Please enter your credentials to login' 
                  : 'Already have an account? Switch to Sign In above',
                style: GoogleFonts.outfit(color: Colors.white24, fontSize: 11),
              ),
            ),
            const SizedBox(height: 12),
            if (_tab == 'signup') ...[
              _label('FULL NAME'),
              _input(_nameController, 'Maya Johnson'),
              const SizedBox(height: 16),
              _label('I AM A...'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: const Color(0xFF0D0D2B), borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UserRole>(
                    value: _role,
                    dropdownColor: const Color(0xFF111130),
                    isExpanded: true,
                    items: UserRole.values.map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.name.substring(0, 1).toUpperCase() + r.name.substring(1), style: GoogleFonts.outfit(fontSize: 14, color: Colors.white)),
                    )).toList(),
                    onChanged: (val) => setState(() => _role = val!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _label('EMAIL ADDRESS'),
            _input(_emailController, 'you@example.com'),
            const SizedBox(height: 16),
            _label('PASSWORD'),
            _input(_pwController, 'Your password', isPassword: true),
            const SizedBox(height: 16),
            if (auth.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(auth.error!, style: GoogleFonts.outfit(color: Colors.redAccent, fontSize: 12)),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.loading ? null : () async {
                  bool success;
                  if (_tab == 'signin') {
                    success = await auth.signIn(_emailController.text, _pwController.text);
                  } else {
                    success = await auth.signUp(_nameController.text, _emailController.text, _pwController.text, _role);
                  }
                  if (mounted && success) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: auth.loading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(_tab == 'signin' ? 'Sign In' : 'Create Account'),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _tabBtn(String val, String label) {
    bool active = _tab == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = val),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF111130) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)] : null,
          ),
          child: Text(label, textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.white38)),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)));
  }

  Widget _input(TextEditingController controller, String hint, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_showPw,
      style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF0D0D2B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: isPassword ? IconButton(icon: Icon(_showPw ? LucideIcons.eyeOff : LucideIcons.eye, size: 16, color: Colors.white38), onPressed: () => setState(() => _showPw = !_showPw)) : null,
      ),
    );
  }
}
