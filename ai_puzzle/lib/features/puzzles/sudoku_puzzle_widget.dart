import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../algorithms/sudoku_solver.dart';

class SudokuPuzzleWidget extends StatefulWidget {
  final String difficulty;
  final VoidCallback onSolved;
  final bool isAutoSolveRequested;

  const SudokuPuzzleWidget({
    super.key,
    this.difficulty = 'easy',
    required this.onSolved,
    this.isAutoSolveRequested = false,
  });

  @override
  State<SudokuPuzzleWidget> createState() => SudokuPuzzleWidgetState();
}

class SudokuPuzzleWidgetState extends State<SudokuPuzzleWidget> {
  late List<List<int>> _initialGrid;
  late List<List<int>> _currentGrid;
  int? _selectedRow;
  int? _selectedCol;
  int _mistakes = 0;
  bool _isAutoSolving = false;
  String _solverStatus = '';

  @override
  void initState() {
    super.initState();
    _generateNewPuzzle();
  }

  @override
  void didUpdateWidget(SudokuPuzzleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAutoSolveRequested && !oldWidget.isAutoSolveRequested && !_isAutoSolving) {
      triggerAutoSolve();
    }
  }

  void _generateNewPuzzle() {
    final generated = SudokuSolver.generateSudoku(widget.difficulty);
    final puzzle = generated['puzzle'] as List<List<int>>;

    setState(() {
      _initialGrid = puzzle.map((r) => List<int>.from(r)).toList();
      _currentGrid = puzzle.map((r) => List<int>.from(r)).toList();
      _selectedRow = null;
      _selectedCol = null;
      _mistakes = 0;
      _isAutoSolving = false;
      _solverStatus = '';
    });
  }

  void _selectCell(int r, int c) {
    if (_isAutoSolving) return;
    setState(() {
      _selectedRow = r;
      _selectedCol = c;
    });
  }

  void _enterNumber(int number) {
    if (_selectedRow == null || _selectedCol == null || _isAutoSolving) return;
    final r = _selectedRow!;
    final c = _selectedCol!;

    // Cannot modify initial given clues
    if (_initialGrid[r][c] != 0) return;

    if (number != 0 && !SudokuSolver.isValidPlacement(_currentGrid, r, c, number)) {
      setState(() {
        _mistakes++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conflict detected! Number violates row, column, or 3x3 box rule.'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }

    setState(() {
      _currentGrid[r][c] = number;
    });

    _checkIfSolved();
  }

  void _checkIfSolved() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (_currentGrid[r][c] == 0) return;
      }
    }
    // All filled, verify
    final res = SudokuSolver.solve(_currentGrid);
    if (res.isSolvable) {
      widget.onSolved();
    }
  }

  Future<void> triggerAutoSolve() async {
    setState(() {
      _isAutoSolving = true;
      _solverStatus = 'Executing recursive backtracking algorithm...';
    });

    final res = SudokuSolver.solve(_initialGrid, recordTrace: true, maxTrace: 60);

    if (!res.isSolvable) {
      setState(() {
        _isAutoSolving = false;
        _solverStatus = 'Unsolvable board configuration.';
      });
      return;
    }

    setState(() {
      _solverStatus = 'Backtracking solved in ${res.stepsCount} steps (${res.executionTime.inMilliseconds}ms). Animating trace...';
    });

    // Animate trace steps with clear step-by-step visual pacing
    for (final step in res.traceSteps) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 350));
      setState(() {
        _currentGrid[step.row][step.col] = step.value;
      });
    }

    // Set full solved grid
    setState(() {
      _currentGrid = res.solvedGrid.map((r) => List<int>.from(r)).toList();
      _isAutoSolving = false;
      _solverStatus = 'Sudoku Solved!';
    });

    widget.onSolved();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Mistakes & Status HUD
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mistakes: $_mistakes/3',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: _mistakes > 0 ? AppColors.error : AppColors.secondaryText,
                ),
              ),
              Text(
                'Tier: ${widget.difficulty.toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.accentPurple),
              ),
            ],
          ),
        ),
        if (_solverStatus.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              _solverStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.accentPurple, fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(height: 6),

        // 9x9 Board
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryText, width: 2),
            ),
            child: Column(
              children: List.generate(9, (row) {
                return Expanded(
                  child: Row(
                    children: List.generate(9, (col) {
                      final val = _currentGrid[row][col];
                      final isGiven = _initialGrid[row][col] != 0;
                      final isSelected = _selectedRow == row && _selectedCol == col;
                      final inSameRowCol = _selectedRow == row || _selectedCol == col;

                      Color cellColor;
                      if (isSelected) {
                        cellColor = AppColors.accentLavender;
                      } else if (inSameRowCol && _selectedRow != null) {
                        cellColor = isDark ? Colors.white10 : const Color(0xFFF1F5F9);
                      } else {
                        cellColor = Colors.transparent;
                      }

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _selectCell(row, col),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cellColor,
                              border: Border(
                                right: BorderSide(
                                  color: col % 3 == 2 && col != 8 ? AppColors.primaryText : AppColors.border,
                                  width: col % 3 == 2 && col != 8 ? 2 : 0.8,
                                ),
                                bottom: BorderSide(
                                  color: row % 3 == 2 && row != 8 ? AppColors.primaryText : AppColors.border,
                                  width: row % 3 == 2 && row != 8 ? 2 : 0.8,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                val != 0 ? '$val' : '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isGiven ? FontWeight.w800 : FontWeight.w600,
                                  color: isGiven
                                      ? (isDark ? Colors.white : AppColors.primaryText)
                                      : AppColors.accentPurple,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Keypad 1-9 & Eraser
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(9, (index) {
            final num = index + 1;
            return GestureDetector(
              onTap: () => _enterNumber(num),
              child: Container(
                width: 34,
                height: 42,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBackground : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    '$num',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),

        // Eraser & Action buttons
        Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: () => _enterNumber(0),
                icon: const Icon(Icons.backspace_outlined, size: 18),
                label: const Text('Erase', maxLines: 1, overflow: TextOverflow.ellipsis),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isAutoSolving ? null : triggerAutoSolve,
                icon: const Icon(Icons.smart_toy_outlined, size: 18),
                label: const Text('Auto-Solve', maxLines: 1, overflow: TextOverflow.ellipsis),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
