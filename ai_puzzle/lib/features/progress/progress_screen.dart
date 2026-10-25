import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/local_storage_service.dart';

class ProgressScreen extends StatelessWidget {
  final LocalStorageService storage;

  const ProgressScreen({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final solvedCount = storage.solvedPuzzleIds.length;
    final xp = storage.totalXP;
    final streak = storage.streak;
    final highestStreak = storage.highestStreak;
    final level = (xp / 100).floor() + 1;

    final achievements = [
      {'title': 'First Deduction', 'desc': 'Solve your first challenge', 'done': solvedCount >= 1},
      {'title': 'Curious Mind', 'desc': 'Solve 5 challenges across any domain', 'done': solvedCount >= 5},
      {'title': 'Algorithmic Master', 'desc': 'Reach Level 3 (200+ XP)', 'done': level >= 3},
      {'title': 'Streak Devotee', 'desc': 'Maintain a 3-day streak', 'done': streak >= 3 || highestStreak >= 3},
      {'title': 'Turing Disciple', 'desc': 'Solve 15 challenges across categories', 'done': solvedCount >= 15},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Progress & Mastery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: 'Puzzles Solved',
                    value: '$solvedCount',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: 'Total XP',
                    value: '$xp',
                    icon: Icons.bolt,
                    color: AppColors.accentPurple,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: 'Current Streak',
                    value: '$streak Days',
                    icon: Icons.local_fire_department,
                    color: AppColors.warning,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: 'Cognitive Tier',
                    value: 'Level $level',
                    icon: Icons.military_tech_outlined,
                    color: AppColors.info,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Achievements List
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),

            ...achievements.map((ach) {
              final isDone = ach['done'] as bool;
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.successLight : (isDark ? Colors.white10 : AppColors.borderSubtle),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDone ? Icons.verified : Icons.lock_outline,
                      color: isDone ? AppColors.success : AppColors.secondaryText,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    ach['title'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: isDone ? null : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(ach['desc'] as String),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
