import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'providers/auth_provider.dart';
import 'widgets/navbar.dart';
import 'widgets/hero.dart';
import 'widgets/stats.dart';
import 'widgets/about.dart';
import 'widgets/programs.dart';
import 'widgets/testimonials.dart';
import 'widgets/team.dart';
import 'widgets/events.dart';
import 'widgets/get_involved.dart';
import 'widgets/contact.dart';
import 'widgets/footer.dart';
import 'widgets/auth_modal.dart';
import 'screens/learning/class_view.dart';
import 'screens/learning/enrollment_form.dart';
import 'widgets/code_playground_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const YouthWebsiteApp(),
    ),
  );
}

class YouthWebsiteApp extends StatelessWidget {
  const YouthWebsiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code4Youth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D2B),
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 40 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 40 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _openAuth(String tab) {
    showDialog(
      context: context,
      builder: (context) => AuthModal(defaultTab: tab),
    );
  }

  void _openCodePlayground() {
    showDialog(
      context: context,
      builder: (context) => const CodePlaygroundModal(),
    );
  }

  Future<void> _handleApply(String programName) async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      _openAuth('signup');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${auth.baseUrl}/check-registration?userId=${auth.user!.id}&className=$programName'),
      );
      final data = jsonDecode(response.body);

      if (data['isRegistered']) {
        if (mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ClassViewScreen(className: programName)));
        }
      } else {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnrollmentFormScreen(
                className: programName,
                price: programName == 'AI Lab' ? 99.00 : 49.00,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Registration check error: $e');
    }
  }

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _programsKey = GlobalKey();
  final GlobalKey _impactKey = GlobalKey();
  final GlobalKey _teamKey = GlobalKey();
  final GlobalKey _eventsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final List<String> navItems = ['About', 'Programs', 'Impact', 'Team', 'Events', 'Contact'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Navbar(
          isScrolled: _isScrolled,
          onLinkTap: (label) {
            if (label == 'Home') {
              _scrollController.animateTo(0, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
            }
            if (label == 'About') _scrollTo(_aboutKey);
            if (label == 'Programs') _scrollTo(_programsKey);
            if (label == 'Impact') _scrollTo(_impactKey);
            if (label == 'Team') _scrollTo(_teamKey);
            if (label == 'Events') _scrollTo(_eventsKey);
            if (label == 'Contact') _scrollTo(_contactKey);
          },
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF0D0D2B),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Navigation',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10),
              Expanded(
                child: ListView(
                  children: navItems.map((item) => ListTile(
                    title: Text(
                      item,
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (item == 'About') _scrollTo(_aboutKey);
                      if (item == 'Programs') _scrollTo(_programsKey);
                      if (item == 'Impact') _scrollTo(_impactKey);
                      if (item == 'Team') _scrollTo(_teamKey);
                      if (item == 'Events') _scrollTo(_eventsKey);
                      if (item == 'Contact') _scrollTo(_contactKey);
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCodePlayground,
        backgroundColor: const Color(0xFFFF6B35),
        hoverColor: const Color(0xFFE65A2B),
        icon: const Icon(LucideIcons.code2, color: Colors.white),
        label: const Text('Practice Coding', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(onExploreTap: () => _scrollTo(_programsKey)),
            StatsSection(key: _impactKey),
            AboutSection(key: _aboutKey),
            ProgramsSection(
              key: _programsKey,
              onApplyTap: (name) => _handleApply(name),
            ),
            const TestimonialsSection(),
            TeamSection(key: _teamKey),
            EventsSection(key: _eventsKey),
            GetInvolvedSection(
              onApplyTap: () => _handleApply('General Interest'),
            ),
            ContactSection(key: _contactKey),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
