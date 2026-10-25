import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.explore_outlined,
      'title': 'Explore 15 Puzzle Domains',
      'subtitle': 'From classical sliding tiles and Sudoku to Bayesian probability and cryptograms. A boundless arena for curious minds.',
      'badge': 'DIVERSE WORLDS',
    },
    {
      'icon': Icons.psychology_outlined,
      'title': 'Intelligent AI Assistance',
      'subtitle': 'Ask for progressive gentle clues, inspect mistake explanations, or watch step-by-step verified algorithmic solvers.',
      'badge': 'HYBRID INTELLIGENCE',
    },
    {
      'icon': Icons.insights_outlined,
      'title': 'Elevate Your Cognitive Peak',
      'subtitle': 'Track your streak, earn XP, unlock achievements, and enjoy real offline-first intelligence at your fingertips.',
      'badge': 'PROGRESSION & MASTERY',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Skip action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PUZZLEVERSE AI',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 14,
                      color: AppColors.accentPurple,
                    ),
                  ),
                  if (_currentIndex < _pages.length - 1)
                    TextButton(
                      onPressed: widget.onFinish,
                      child: const Text('Skip', style: TextStyle(color: AppColors.secondaryText)),
                    ),
                ],
              ),
            ),
            // Page view carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardBackground : AppColors.accentLavender.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentPurple.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 72,
                            color: AppColors.accentPurple,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accentPurple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            page['badge'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppColors.accentPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          page['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots & Action buttons
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentIndex == i ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == i
                              ? AppColors.accentPurple
                              : (isDark ? Colors.white24 : AppColors.border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        widget.onFinish();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    ),
                    child: Text(
                      _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
