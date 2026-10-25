import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/repositories/puzzle_repository.dart';

class DailyChallengeScreen extends StatefulWidget {
  final PuzzleRepository repository;
  final Function(PuzzleModel) onStartChallenge;

  const DailyChallengeScreen({
    super.key,
    required this.repository,
    required this.onStartChallenge,
  });

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  PuzzleModel? _dailyPuzzle;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDaily();
  }

  Future<void> _loadDaily() async {
    final now = DateTime.now();
    final categories = PuzzleCategory.values;
    final cat = categories[now.day % categories.length];

    final list = await widget.repository.getPuzzlesForCategory(cat);
    if (mounted) {
      setState(() {
        _dailyPuzzle = list.isNotEmpty ? list.first : null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[today.month - 1]} ${today.day}, ${today.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Challenge')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dailyPuzzle == null
              ? const Center(child: Text('No challenge available today.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      // Calendar Badge
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.accentLavender.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.accentPurple,
                          size: 54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dailyPuzzle!.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _dailyPuzzle!.category.displayName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card detail
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardBackground : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Objective',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.secondaryText),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _dailyPuzzle!.description,
                              style: const TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.bolt, color: AppColors.accentPurple, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  'Reward: +${_dailyPuzzle!.difficulty.baseXP} XP',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => widget.onStartChallenge(_dailyPuzzle!),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Start Daily Challenge'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
