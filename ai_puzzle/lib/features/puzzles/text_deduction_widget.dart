import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/puzzle_model.dart';

class TextDeductionWidget extends StatefulWidget {
  final PuzzleModel puzzle;
  final VoidCallback onSolved;
  final bool isAutoSolveRequested;

  const TextDeductionWidget({
    super.key,
    required this.puzzle,
    required this.onSolved,
    this.isAutoSolveRequested = false,
  });

  @override
  State<TextDeductionWidget> createState() => TextDeductionWidgetState();
}

class TextDeductionWidgetState extends State<TextDeductionWidget> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;
  bool _isAnswerRevealed = false;
  bool _isAutoSolving = false;
  String? _autoSolveClueProgress;

  @override
  void didUpdateWidget(TextDeductionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAutoSolveRequested && !oldWidget.isAutoSolveRequested && !_isAutoSolving) {
      triggerAutoSolve();
    }
  }

  void _submitAnswer() {
    if (_isAutoSolving) return;
    final input = _controller.text.trim().toLowerCase();
    if (input.isEmpty) return;

    final isCorrect = widget.puzzle.validAnswers.any((ans) {
      final normalized = ans.trim().toLowerCase();
      return input == normalized || input.contains(normalized);
    });

    if (isCorrect) {
      setState(() {
        _errorMessage = null;
        _isAnswerRevealed = true;
      });
      widget.onSolved();
    } else {
      setState(() {
        _errorMessage = 'Incorrect deduction. Check clues or ask for a hint!';
      });
    }
  }

  /// Deliberate step-by-step Auto-Solve:
  /// Step 1: Reveal Gentle Hint & pause
  /// Step 2: Reveal Guided Hint & pause
  /// Step 3: Reveal Strong Hint & pause
  /// Step 4: Deliberately type the final solution with paced delays
  Future<void> triggerAutoSolve() async {
    if (_isAutoSolving) return;
    setState(() {
      _isAutoSolving = true;
      _errorMessage = null;
      _controller.text = '';
      _autoSolveClueProgress = 'Step 1/4 (Gentle Clue): ${widget.puzzle.hintLadder.gentle}';
    });

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() {
      _autoSolveClueProgress = 'Step 2/4 (Strategy): ${widget.puzzle.hintLadder.guided}';
    });

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() {
      _autoSolveClueProgress = 'Step 3/4 (Strong Deduction): ${widget.puzzle.hintLadder.strong}';
    });

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() {
      _autoSolveClueProgress = 'Step 4/4: Constructing Verified Solution...';
    });

    final targetSolution = widget.puzzle.hintLadder.fullSolution;

    // Paced typing animation: 180ms per letter
    for (int i = 0; i < targetSolution.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 180));
      setState(() {
        _controller.text = targetSolution.substring(0, i + 1);
      });
    }

    // Hold final solved state for 1 second before completion transition
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isAnswerRevealed = true;
        _isAutoSolving = false;
        _autoSolveClueProgress = null;
      });
      widget.onSolved();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imagePath = widget.puzzle.puzzleData['image_path'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question & Visual Puzzle Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentLavender,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.puzzle.category.displayName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentPurple,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.puzzle.difficulty.displayName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accentPurple),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Image Clue for Animal and Bird Puzzles
                if (imagePath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, size: 40, color: AppColors.secondaryText),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                Text(
                  widget.puzzle.description,
                  style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progressive Auto-Solve Clue Box
          if (_autoSolveClueProgress != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentLavender.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentPurple),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _autoSolveClueProgress!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          TextField(
            controller: _controller,
            enabled: !_isAutoSolving,
            decoration: InputDecoration(
              hintText: _isAutoSolving ? 'Deducing step by step...' : 'Enter your deduction...',
              filled: true,
              fillColor: isDark ? AppColors.darkCardBackground : Colors.white,
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.accentPurple),
                onPressed: _isAutoSolving ? null : _submitAnswer,
              ),
            ),
            onSubmitted: (_) => _submitAnswer(),
          ),
          const SizedBox(height: 16),

          // Action buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isAutoSolving ? null : _submitAnswer,
              child: Text(_isAutoSolving ? 'Solving Step-by-Step...' : 'Submit Deduction'),
            ),
          ),

          if (_isAnswerRevealed) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Verified Solution',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.success),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.puzzle.explanation,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF14532D)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
