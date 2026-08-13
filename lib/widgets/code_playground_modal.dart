import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Custom controller to provide basic syntax highlighting
class SyntaxHighlighter extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final List<TextSpan> children = [];
    final pattern = RegExp(
      r"(def\s+\w+)|(print)|(if\s|else\s|for\s|in\s|return\s)|('.*?')|(#.*)|(\d+)",
      multiLine: true,
    );

    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        Color? color;
        FontWeight weight = FontWeight.normal;

        if (match.group(1) != null) color = const Color(0xFFC678DD); // Functions (Purple)
        if (match.group(2) != null) color = const Color(0xFF61AFEF); // Print (Blue)
        if (match.group(3) != null) { color = const Color(0xFFC678DD); weight = FontWeight.bold; } // Keywords
        if (match.group(4) != null) color = const Color(0xFF98C379); // Strings (Green)
        if (match.group(5) != null) color = const Color(0xFF5C6370); // Comments (Grey)
        if (match.group(6) != null) color = const Color(0xFFD19A66); // Numbers (Orange)

        children.add(TextSpan(text: match[0], style: style!.copyWith(color: color, fontWeight: weight)));
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );

    return TextSpan(style: style, children: children);
  }
}

class CodePlaygroundModal extends StatefulWidget {
  const CodePlaygroundModal({super.key});

  @override
  State<CodePlaygroundModal> createState() => _CodePlaygroundModalState();
}

class _CodePlaygroundModalState extends State<CodePlaygroundModal> {
  final SyntaxHighlighter _codeController = SyntaxHighlighter();
  String _output = "> Click Run to see the output...";
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _codeController.text = "def celebrate():\n    print('Hello, Code4Youth!')\n    # Try adding more lines below\n    if 10 > 5:\n        print('Python is amazing!')\n\ncelebrate()";
  }

  void _executeCode() async {
    setState(() {
      _isRunning = true;
      _output = "Compiling script...";
    });

    await Future.delayed(1.seconds);

    String code = _codeController.text;
    String result = "";

    // Simulate multi-line execution
    if (code.contains("print(")) {
      final matches = RegExp(r"print\('(.+?)'\)").allMatches(code);
      if (matches.isNotEmpty) {
        result = matches.map((m) => m.group(1)).join('\n');
      } else {
        result = "Successfully executed with internal logic.";
      }
    } else {
      result = "Execution finished (Process exited with 0).";
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
          color: const Color(0xFF282C34), // One Dark Pro Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(15)),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(150), blurRadius: 50, offset: const Offset(0, 25))
          ],
        ),
        child: Column(
          children: [
            _buildToolbar(context, isMobile),
            Expanded(
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
            _buildStatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF21252B),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(bottom: BorderSide(color: Colors.black.withAlpha(30))),
      ),
      child: Row(
        children: [
          if (!isMobile) ...[
            _dot(const Color(0xFFFF5F56)),
            const SizedBox(width: 8),
            _dot(const Color(0xFFFFBD2E)),
            const SizedBox(width: 8),
            _dot(const Color(0xFF27C93F)),
            const SizedBox(width: 20),
          ],
          const Icon(LucideIcons.binary, size: 16, color: Color(0xFF61AFEF)),
          const SizedBox(width: 10),
          Text('editor.py', style: GoogleFonts.jetBrainsMono(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _executeCode,
            icon: _isRunning 
              ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(LucideIcons.play, size: 12),
            label: const Text('RUN CODE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF98C379),
              foregroundColor: const Color(0xFF282C34),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.white38, size: 18)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(flex: 7, child: _buildEditor()),
        Container(width: 1, color: Colors.black.withAlpha(30)),
        Expanded(flex: 3, child: _buildTerminal()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(flex: 6, child: _buildEditor()),
        Container(height: 1, color: Colors.black.withAlpha(30)),
        Expanded(flex: 4, child: _buildTerminal()),
      ],
    );
  }

  Widget _buildEditor() {
    return Stack(
      children: [
        // Line Numbers Sidebar (Visual only)
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: Container(
            width: 45,
            color: const Color(0xFF21252B).withAlpha(100),
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: List.generate(20, (i) => Text('${i + 1}', style: GoogleFonts.jetBrainsMono(color: Colors.white10, fontSize: 13, height: 1.84))),
            ),
          ),
        ),
        // Code Field
        Padding(
          padding: const EdgeInsets.only(left: 55),
          child: TextField(
            controller: _codeController,
            maxLines: null,
            expands: true,
            style: GoogleFonts.jetBrainsMono(color: const Color(0xFFABB2BF), fontSize: 16, height: 1.5),
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(24)),
            cursorColor: const Color(0xFF61AFEF),
            cursorWidth: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildTerminal() {
    return Container(
      color: const Color(0xFF1E2127),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.terminal, size: 12, color: Colors.white24),
              const SizedBox(width: 10),
              Text('OUTPUT', style: GoogleFonts.plusJakartaSans(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_output, style: GoogleFonts.jetBrainsMono(color: const Color(0xFF61AFEF), fontSize: 14, height: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      color: const Color(0xFF21252B),
      child: Row(
        children: [
          _statusItem(LucideIcons.gitBranch, 'main*'),
          const SizedBox(width: 20),
          _statusItem(LucideIcons.refreshCw, 'Python 3.12'),
          const Spacer(),
          _statusItem(null, 'UTF-8'),
          const SizedBox(width: 20),
          _statusItem(null, 'Spaces: 4'),
        ],
      ),
    );
  }

  Widget _statusItem(IconData? icon, String text) {
    return Row(
      children: [
        if (icon != null) ...[Icon(icon, size: 12, color: Colors.white38), const SizedBox(width: 6)],
        Text(text, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11)),
      ],
    );
  }

  Widget _dot(Color color) => Container(width: 11, height: 11, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}
