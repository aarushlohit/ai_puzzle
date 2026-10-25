import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/puzzle_model.dart';
import '../../services/puzzle_ai_service.dart';
import '../../data/database/local_storage_service.dart';
import '../ai_assistant/ai_assistant_modal.dart';
import '../puzzles/sliding_puzzle_widget.dart';
import '../puzzles/sudoku_puzzle_widget.dart';
import '../puzzles/maze_puzzle_widget.dart';
import '../puzzles/text_deduction_widget.dart';
import '../puzzles/photo_jigsaw_widget.dart';
import 'victory_screen.dart';

class GameplayScreen extends StatefulWidget {
  final PuzzleModel puzzle;
  final PuzzleAIService aiService;
  final LocalStorageService storage;
  final VoidCallback onExit;

  const GameplayScreen({
    super.key,
    required this.puzzle,
    required this.aiService,
    required this.storage,
    required this.onExit,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late Stopwatch _stopwatch;
  Timer? _timer;
  int _hintsUsed = 0;
  bool _isAutoSolveRequested = false;
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _onPuzzleSolved() {
    if (_isSolved) return;
    _isSolved = true;
    _stopwatch.stop();
    _timer?.cancel();

    final session = PuzzleSession(
      puzzleId: widget.puzzle.id,
      category: widget.puzzle.category,
      difficulty: widget.puzzle.difficulty,
      hintsUsed: _hintsUsed,
      isAutoSolved: _isAutoSolveRequested,
      isCompleted: true,
      duration: _stopwatch.elapsed,
    );

    final xpEarned = session.calculateXP();
    widget.storage.addXP(xpEarned);
    widget.storage.markPuzzleSolved(widget.puzzle.id);
    widget.storage.recordDailyPlay();

    // Schedule navigation safely after current frame completes to prevent setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VictoryScreen(
            puzzle: widget.puzzle,
            session: session,
            earnedXP: xpEarned,
            onContinue: () {
              Navigator.pop(context); // Pop Victory
              widget.onExit(); // Exit back to levels
            },
          ),
        ),
      );
    });
  }

  void _openAIAssistant() {
    setState(() => _hintsUsed++);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AIAssistantModal(
        puzzle: widget.puzzle,
        aiService: widget.aiService,
        onAutoSolve: () {
          setState(() {
            _isAutoSolveRequested = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final elapsedSec = _stopwatch.elapsed.inSeconds;
    final minutes = (elapsedSec ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSec % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology_outlined, color: AppColors.accentPurple),
            tooltip: 'AI Assistant',
            onPressed: _openAIAssistant,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gameplay Header HUD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accentLavender.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 16, color: AppColors.accentPurple),
                          const SizedBox(width: 4),
                          Text(
                            '$minutes:$seconds',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Hints: $_hintsUsed',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondaryText),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAutoSolveRequested = true;
                        });
                      },
                      icon: const Icon(Icons.auto_fix_high, size: 14),
                      label: const Text('Auto-Solve', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Dynamic Category Game Engine Widget
              _buildPuzzleWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPuzzleWidget() {
    switch (widget.puzzle.category) {
      case PuzzleCategory.sliding:
        final size = widget.puzzle.puzzleData['size'] as int? ?? 3;
        final scramble = widget.puzzle.puzzleData['scramble'] as int? ?? 8;
        return SlidingPuzzleWidget(
          size: size,
          scrambleSteps: scramble,
          onSolved: _onPuzzleSolved,
          isAutoSolveRequested: _isAutoSolveRequested,
        );

      case PuzzleCategory.sudoku:
        final diff = widget.puzzle.puzzleData['difficulty'] as String? ?? 'easy';
        return SudokuPuzzleWidget(
          difficulty: diff,
          onSolved: _onPuzzleSolved,
          isAutoSolveRequested: _isAutoSolveRequested,
        );

      case PuzzleCategory.maze:
        final rows = widget.puzzle.puzzleData['rows'] as int? ?? 15;
        final cols = widget.puzzle.puzzleData['cols'] as int? ?? 15;
        return MazePuzzleWidget(
          rows: rows,
          cols: cols,
          onSolved: _onPuzzleSolved,
          isAutoSolveRequested: _isAutoSolveRequested,
        );

      // If puzzle contains an image_path, route to interactive Photo Jigsaw
      default:
        final imgPath = widget.puzzle.puzzleData['image_path'] as String?;
        if (imgPath != null && imgPath.isNotEmpty) {
          final targetName = widget.puzzle.puzzleData['target_name'] as String? ?? widget.puzzle.title;
          return PhotoJigsawWidget(
            imagePath: imgPath,
            title: widget.puzzle.title,
            description: widget.puzzle.description,
            answerName: targetName,
            gentleHint: widget.puzzle.hintLadder.gentle,
            guidedHint: widget.puzzle.hintLadder.guided,
            strongHint: widget.puzzle.hintLadder.strong,
            gridSize: 3,
            onSolved: _onPuzzleSolved,
            isAutoSolveRequested: _isAutoSolveRequested,
          );
        }
        return TextDeductionWidget(
          puzzle: widget.puzzle,
          onSolved: _onPuzzleSolved,
          isAutoSolveRequested: _isAutoSolveRequested,
        );
    }
  }
}
