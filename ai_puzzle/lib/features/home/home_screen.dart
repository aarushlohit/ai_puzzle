import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/database/local_storage_service.dart';

class HomeScreen extends StatelessWidget {
  final LocalStorageService storage;
  final Function(PuzzleCategory) onSelectCategory;
  final VoidCallback onDailyChallenge;
  final VoidCallback onOpenVisualizer;

  const HomeScreen({
    super.key,
    required this.storage,
    required this.onSelectCategory,
    required this.onDailyChallenge,
    required this.onOpenVisualizer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streak = storage.streak;
    final xp = storage.totalXP;
    final level = (xp / 100).floor() + 1;
    final progressToNextLevel = (xp % 100) / 100.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PUZZLEVERSE AI',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: AppColors.accentPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome, Explorer',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  // Daily streak pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.warning, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '$streak Day Streak',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Player Level Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentPurple, Color(0xFF9078F8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentPurple.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LEVEL $level',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Cognitive Scholar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$xp Total XP',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progressToNextLevel,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(progressToNextLevel * 100).toInt()}% to Level ${level + 1}',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Daily Challenge Banner
              GestureDetector(
                onTap: onDailyChallenge,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBackground : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accentLavender.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, color: AppColors.accentPurple, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI Daily Challenge',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Complete today\'s challenge to keep your streak!',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.accentPurple),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Algorithm Visualizer CTA (Academic Showcase)
              GestureDetector(
                onTap: onOpenVisualizer,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.account_tree_outlined, color: Color(0xFF6366F1), size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI Algorithm Visualizer',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            Text(
                              'Inspect live BFS, DFS, A*, & Backtracking steps',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF6366F1)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                    ),
                  ),
                  Text(
                    '15 Domains',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: [
                  _categoryCard(
                    context,
                    title: 'Sliding Puzzle',
                    subtitle: 'A* & IDA* Search',
                    icon: Icons.grid_view_rounded,
                    category: PuzzleCategory.sliding,
                  ),
                  _categoryCard(
                    context,
                    title: 'Sudoku Masters',
                    subtitle: 'Backtracking Solver',
                    icon: Icons.border_all_rounded,
                    category: PuzzleCategory.sudoku,
                  ),
                  _categoryCard(
                    context,
                    title: 'Maze Solver',
                    subtitle: 'BFS & Heuristics',
                    icon: Icons.alt_route_rounded,
                    category: PuzzleCategory.maze,
                  ),
                  _categoryCard(
                    context,
                    title: 'Mathematical',
                    subtitle: 'Sequences & Bayes',
                    icon: Icons.calculate_outlined,
                    category: PuzzleCategory.mathematics,
                  ),
                  _categoryCard(
                    context,
                    title: 'Animal Mysteries',
                    subtitle: 'Clue Deduction',
                    icon: Icons.pets_outlined,
                    category: PuzzleCategory.animals,
                  ),
                  _categoryCard(
                    context,
                    title: 'Detective Cases',
                    subtitle: 'Forensic Logic',
                    icon: Icons.search_rounded,
                    category: PuzzleCategory.detective,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required PuzzleCategory category,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onSelectCategory(category),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentLavender.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.accentPurple, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
