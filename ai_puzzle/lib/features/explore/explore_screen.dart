import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/puzzle_model.dart';

class ExploreScreen extends StatelessWidget {
  final Function(PuzzleCategory) onSelectCategory;

  const ExploreScreen({super.key, required this.onSelectCategory});

  final List<Map<String, dynamic>> _allCategories = const [
    {
      'category': PuzzleCategory.sliding,
      'title': 'Sliding Number Puzzle',
      'description': '3x3, 4x4, and 5x5 boards solved via A* Manhattan & IDA*',
      'icon': Icons.grid_view_rounded,
      'difficulty': 'Easy to Insane',
      'challenges': '12 Levels',
    },
    {
      'category': PuzzleCategory.sudoku,
      'title': 'Sudoku Masters',
      'description': '9x9 constraint logic grids with backtracking solver & trace',
      'icon': Icons.border_all_rounded,
      'difficulty': 'All Tiers',
      'challenges': 'Unique Solutions',
    },
    {
      'category': PuzzleCategory.maze,
      'title': 'Maze Solver',
      'description': 'Randomized DFS generation with live BFS & A* comparison',
      'icon': Icons.alt_route_rounded,
      'difficulty': 'Medium to Expert',
      'challenges': 'Infinite Gen',
    },
    {
      'category': PuzzleCategory.mathematics,
      'title': 'Mathematical Puzzles',
      'description': 'Sequences, missing terms, and Bayesian probability reasoning',
      'icon': Icons.calculate_outlined,
      'difficulty': 'Multi-Step',
      'challenges': 'Deterministic',
    },
    {
      'category': PuzzleCategory.animals,
      'title': 'Animal Mysteries',
      'description': 'Anatomical deduction, ecological food chains, and taxonomy',
      'icon': Icons.pets_outlined,
      'difficulty': 'Deduction',
      'challenges': 'Authored Seeds',
    },
    {
      'category': PuzzleCategory.birds,
      'title': 'Bird Intelligence',
      'description': 'Avian navigation, beak adaptations, and aerodynamic wonders',
      'icon': Icons.flutter_dash_rounded,
      'difficulty': 'Nature AI',
      'challenges': 'Verified Facts',
    },
    {
      'category': PuzzleCategory.gk,
      'title': 'General Knowledge',
      'description': 'History of science, cosmology, and computing pioneers',
      'icon': Icons.public_rounded,
      'difficulty': 'Broad Scope',
      'challenges': 'Verified Trivia',
    },
    {
      'category': PuzzleCategory.logic,
      'title': 'Logical Reasoning',
      'description': 'Knights and Knaves, truth tables, and constraint satisfaction',
      'icon': Icons.psychology_outlined,
      'difficulty': 'Pure Logic',
      'challenges': 'Multi-Step',
    },
    {
      'category': PuzzleCategory.patterns,
      'title': 'Pattern Recognition',
      'description': 'Geometric sequences, cyclic groups, and visual invariances',
      'icon': Icons.scatter_plot_outlined,
      'difficulty': 'Visual IQ',
      'challenges': 'Analytical',
    },
    {
      'category': PuzzleCategory.words,
      'title': 'Word Puzzles',
      'description': 'Word ladders with 1-letter delta, anagrams, and palindromes',
      'icon': Icons.text_fields_rounded,
      'difficulty': 'Linguistic',
      'challenges': 'Lexical Valid',
    },
    {
      'category': PuzzleCategory.cryptography,
      'title': 'Cryptography Puzzles',
      'description': 'Caesar ciphers, ROT13, Atbash, and frequency challenges',
      'icon': Icons.lock_outline_rounded,
      'difficulty': 'Cryptanalysis',
      'challenges': 'Code Breaking',
    },
    {
      'category': PuzzleCategory.memory,
      'title': 'Memory Challenges',
      'description': 'Spatial recall, symbol matrix memory, and matching trials',
      'icon': Icons.remove_red_eye_outlined,
      'difficulty': 'Dynamic',
      'challenges': 'Cognitive',
    },
    {
      'category': PuzzleCategory.chess,
      'title': 'Chess Tactics',
      'description': 'Back-rank mates, smothered mates, and classical sacrifices',
      'icon': Icons.sports_esports_outlined,
      'difficulty': 'Grandmaster',
      'challenges': 'Tactical Lines',
    },
    {
      'category': PuzzleCategory.detective,
      'title': 'Detective Mysteries',
      'description': 'Crime scene forensic deduction and suspect timeline analysis',
      'icon': Icons.search_rounded,
      'difficulty': 'Forensic',
      'challenges': 'Crime Scenes',
    },
    {
      'category': PuzzleCategory.mixed,
      'title': 'AI Mixed Challenge',
      'description': 'Hybrid challenges bridging math, geometry, and Turing logic',
      'icon': Icons.auto_awesome_outlined,
      'difficulty': 'Cap-Stone',
      'challenges': 'Multi-Stage',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All 15 Categories'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _allCategories.length,
        itemBuilder: (context, index) {
          final item = _allCategories[index];
          final cat = item['category'] as PuzzleCategory;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onSelectCategory(cat),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentLavender.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.accentPurple,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['title'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.accentPurple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['difficulty'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['description'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
