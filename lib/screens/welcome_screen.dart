import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_modal.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Geometric Background
          Positioned(top: -100, right: -100, child: _circle(AppColors.primary100, 300)),
          Positioned(bottom: -50, left: -50, child: _circle(AppColors.accent50, 200)),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                children: [
                  const Spacer(),
                  // Logo Placeholder
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: AppColors.primary600, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.code, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  Text('Code4Youth', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary600)),
                  const SizedBox(height: 12),
                  const Text('Empowering the next generation of builders.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  const Spacer(),
                  
                  // Buttons as per UI guidelines
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showAuth(context, 'signup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showAuth(context, 'signin'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary600, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('I already have an account', style: TextStyle(color: AppColors.primary600, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAuth(BuildContext context, String tab) {
    showDialog(context: context, builder: (context) => AuthModal(defaultTab: tab));
  }

  Widget _circle(Color color, double size) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.3)));
  }
}
