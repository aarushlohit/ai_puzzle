import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/repositories/puzzle_repository.dart';

class LevelSelectScreen extends StatefulWidget {
  final PuzzleCategory category;
  final PuzzleRepository repository;
  final Function(PuzzleModel) onSelectPuzzle;

  const LevelSelectScreen({
    super.key,
    required this.category,
    required this.repository,
    required this.onSelectPuzzle,
  });

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  List<PuzzleModel> _puzzles = [];
  bool _isLoading = true;
  PuzzleDifficulty? _filterDifficulty;

  @override
  void initState() {
    super.initState();
    _loadCategoryPuzzles();
  }

  Future<void> _loadCategoryPuzzles() async {
    final list = await widget.repository.getPuzzlesForCategory(widget.category);
    if (mounted) {
      setState(() {
        _puzzles = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _filterDifficulty == null
        ? _puzzles
        : _puzzles.where((p) => p.difficulty == _filterDifficulty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.displayName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Difficulty Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _filterChip('All', null),
                      _filterChip('Easy', PuzzleDifficulty.easy),
                      _filterChip('Medium', PuzzleDifficulty.medium),
                      _filterChip('Hard', PuzzleDifficulty.hard),
                      _filterChip('Expert', PuzzleDifficulty.expert),
                      _filterChip('Insane', PuzzleDifficulty.insane),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No puzzles found for selected filter.',
                            style: TextStyle(
                              color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final puzzle = filtered[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                title: Text(
                                  puzzle.title,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(
                                  puzzle.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _difficultyColor(puzzle.difficulty).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    puzzle.difficulty.displayName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: _difficultyColor(puzzle.difficulty),
                                    ),
                                  ),
                                ),
                                onTap: () => widget.onSelectPuzzle(puzzle),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _filterChip(String label, PuzzleDifficulty? diff) {
    final isSelected = _filterDifficulty == diff;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          setState(() {
            _filterDifficulty = val ? diff : null;
          });
        },
        selectedColor: AppColors.accentPurple,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Color _difficultyColor(PuzzleDifficulty diff) {
    switch (diff) {
      case PuzzleDifficulty.easy:
        return AppColors.success;
      case PuzzleDifficulty.medium:
        return AppColors.info;
      case PuzzleDifficulty.hard:
        return AppColors.warning;
      case PuzzleDifficulty.expert:
        return AppColors.error;
      case PuzzleDifficulty.insane:
        return Colors.purple;
    }
  }
}
