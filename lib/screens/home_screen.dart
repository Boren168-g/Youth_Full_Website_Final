import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/learning_provider.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().fetchModules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final learning = context.watch<LearningProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Code4Youth', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _statBadge(Icons.local_fire_department, user?.streak.toString() ?? '0', AppColors.accent500),
          _statBadge(Icons.stars, user?.points.toString() ?? '0', AppColors.primary500),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => learning.fetchModules(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back,', style: Theme.of(context).textTheme.bodyLarge),
              Text(user?.name ?? 'Learner', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
              const SizedBox(height: 24),
              if (learning.modules.isNotEmpty) 
                _currentModuleCard(context, learning.modules.first)
              else if (learning.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                const Text('Start your first module below!'),
              const SizedBox(height: 32),
              Text('Your Learning Path', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
              const SizedBox(height: 16),
              ...learning.modules.map((m) => _moduleItem(m)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBadge(IconData icon, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _currentModuleCard(BuildContext context, Module module) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary600, AppColors.primary500]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary600.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CONTINUE LEARNING', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(module.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          LinearProgressIndicator(value: module.progress, backgroundColor: Colors.white24, color: AppColors.accent500, borderRadius: BorderRadius.circular(10)),
          const SizedBox(height: 12),
          Text('Lesson ${module.completedLessons} of ${module.totalLessons}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _moduleItem(Module m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: m.isLocked ? Colors.grey.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: m.isLocked ? Colors.grey[200] : AppColors.primary50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(m.isLocked ? Icons.lock : Icons.code, color: m.isLocked ? Colors.grey : AppColors.primary600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.title, style: TextStyle(fontWeight: FontWeight.bold, color: m.isLocked ? Colors.grey : AppColors.textPrimary)),
                Text('${m.completedLessons}/${m.totalLessons} Lessons', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (!m.isLocked) const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
