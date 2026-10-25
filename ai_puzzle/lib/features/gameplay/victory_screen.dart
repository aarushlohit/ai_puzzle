import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/puzzle_model.dart';

class VictoryScreen extends StatelessWidget {
  final PuzzleModel puzzle;
  final PuzzleSession session;
  final int earnedXP;
  final VoidCallback onContinue;

  const VictoryScreen({
    super.key,
    required this.puzzle,
    required this.session,
    required this.earnedXP,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duration = session.duration ?? Duration.zero;
    final timeStr = '${duration.inMinutes}m ${duration.inSeconds % 60}s';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Celebration Badge
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                session.isAutoSolved ? 'AI Solution Solved' : 'Challenge Complete!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                puzzle.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 28),

              // Metrics Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _metricRow('Earned XP', '+$earnedXP XP', isHighlight: true),
                    const Divider(height: 20),
                    _metricRow('Difficulty', puzzle.difficulty.displayName),
                    const Divider(height: 20),
                    _metricRow('Time Taken', timeStr),
                    const Divider(height: 20),
                    _metricRow('Hints Used', '${session.hintsUsed}'),
                    const Divider(height: 20),
                    _metricRow('Status', session.isAutoSolved ? 'AI Assisted' : 'Manual Mastery'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Scientific / Algorithmic Explanation Accordion
              if (puzzle.explanation.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reasoning & Insight',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        puzzle.explanation,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),

              // Next Action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue Journey'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isHighlight ? 18 : 14,
            color: isHighlight ? AppColors.accentPurple : null,
          ),
        ),
      ],
    );
  }
}
