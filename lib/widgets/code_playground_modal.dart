import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CodePlaygroundModal extends StatefulWidget {
  const CodePlaygroundModal({super.key});

  @override
  State<CodePlaygroundModal> createState() => _CodePlaygroundModalState();
}

class _CodePlaygroundModalState extends State<CodePlaygroundModal> {
  final TextEditingController _codeController = TextEditingController(
    text: "def hello_world():\n    print('Hello, Code4Youth!')\n    # Try writing your code here\n\nhello_world()",
  );
  String _output = "> Click Run to see the output...";
  bool _isRunning = false;

  void _executeCode() async {
    setState(() {
      _isRunning = true;
      _output = "Compiling and running...";
    });

    // Simulate execution delay
    await Future.delayed(800.ms);

    String code = _codeController.text;
    String result = "";

    if (code.contains("print('")) {
      final match = RegExp(r"print\('(.+?)'\)").firstMatch(code);
      result = match != null ? match.group(1)! : "Output: Successfully executed.";
    } else {
      result = "Execution finished (no output).";
    }

    setState(() {
      _isRunning = false;
      _output = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 800;

    return Dialog(
      insetPadding: EdgeInsets.all(isMobile ? 12 : 40),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 1100,
        height: size.height * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // VS Code Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(20)),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(150), blurRadius: 40, offset: const Offset(0, 20))
          ],
        ),
        child: Column(
          children: [
            // VS Code Header
            _buildToolbar(context, isMobile),
            
            Expanded(
              child: isMobile 
                ? _buildMobileLayout() 
                : _buildDesktopLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          if (!isMobile) ...[
            _dot(Colors.redAccent),
            const SizedBox(width: 8),
            _dot(Colors.amberAccent),
            const SizedBox(width: 8),
            _dot(Colors.greenAccent),
            const SizedBox(width: 20),
          ],
          const Icon(LucideIcons.fileCode, size: 16, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            'playground.py — Code4Youth',
            style: GoogleFonts.jetBrainsMono(color: Colors.white54, fontSize: 13),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _executeCode,
            icon: _isRunning 
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(LucideIcons.play, size: 14),
            label: const Text('RUN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: Colors.white38, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Code Editor
        Expanded(
          flex: 7,
          child: _editorField(),
        ),
        // Terminal
        Container(width: 1, color: Colors.white.withAlpha(10)),
        Expanded(
          flex: 3,
          child: _terminalView(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(flex: 6, child: _editorField()),
        Container(height: 1, color: Colors.white.withAlpha(10)),
        Expanded(flex: 4, child: _terminalView()),
      ],
    );
  }

  Widget _editorField() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: TextField(
        controller: _codeController,
        maxLines: null,
        expands: true,
        style: GoogleFonts.jetBrainsMono(color: const Color(0xFFD4D4D4), fontSize: 16, height: 1.5),
        decoration: const InputDecoration(border: InputBorder.none),
        cursorColor: Colors.white,
      ),
    );
  }

  Widget _terminalView() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF0D0D0D),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TERMINAL', style: GoogleFonts.plusJakartaSans(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 20),
          Text(
            _output,
            style: GoogleFonts.jetBrainsMono(color: const Color(0xFF00C9A7), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withAlpha(150)));
}
