import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/puzzle_model.dart';
import '../../services/puzzle_ai_service.dart';

class AIAssistantModal extends StatefulWidget {
  final PuzzleModel puzzle;
  final PuzzleAIService aiService;
  final VoidCallback onAutoSolve;

  const AIAssistantModal({
    super.key,
    required this.puzzle,
    required this.aiService,
    required this.onAutoSolve,
  });

  @override
  State<AIAssistantModal> createState() => _AIAssistantModalState();
}

class _AIAssistantModalState extends State<AIAssistantModal> {
  int _currentHintLevel = 1;
  String _hintContent = '';
  bool _isLoading = false;
  String? _strategy;

  @override
  void initState() {
    super.initState();
    _fetchHint(1);
  }

  Future<void> _fetchHint(int level) async {
    setState(() => _isLoading = true);
    final result = await widget.aiService.getHint(widget.puzzle, level);
    if (mounted) {
      setState(() {
        _currentHintLevel = level;
        _hintContent = result.text;
        _strategy = result.strategy;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentLavender.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology, color: AppColors.accentPurple, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'AI Solver Assistant',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Local Rule Engine',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progressive Ladder Tabs
          Row(
            children: [
              _tierButton(1, 'Gentle'),
              const SizedBox(width: 8),
              _tierButton(2, 'Guided'),
              const SizedBox(width: 8),
              _tierButton(3, 'Strong'),
              const SizedBox(width: 8),
              _tierButton(4, 'Solution'),
            ],
          ),
          const SizedBox(height: 16),

          // Hint Display Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _currentHintLevel == 4 ? Icons.lock_open_rounded : Icons.lightbulb_outline,
                            color: AppColors.warning,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _currentHintLevel == 4 ? 'Verified Solution' : 'Hint Tier $_currentHintLevel',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          if (_strategy != null) ...[
                            const Spacer(),
                            Text(
                              _strategy!,
                              style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _hintContent,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 20),

          // Auto-Solve Action
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                widget.onAutoSolve();
              },
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Auto-Solve Step-by-Step'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tierButton(int level, String label) {
    final isSelected = _currentHintLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => _fetchHint(level),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.accentPurple : AppColors.border,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: isSelected ? Colors.white : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
