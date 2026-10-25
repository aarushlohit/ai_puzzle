import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../algorithms/sliding_board.dart';
import '../../../algorithms/astar_solver.dart';

class SlidingPuzzleWidget extends StatefulWidget {
  final int size;
  final int scrambleSteps;
  final VoidCallback onSolved;
  final bool isAutoSolveRequested;

  const SlidingPuzzleWidget({
    super.key,
    required this.size,
    required this.scrambleSteps,
    required this.onSolved,
    this.isAutoSolveRequested = false,
  });

  @override
  State<SlidingPuzzleWidget> createState() => SlidingPuzzleWidgetState();
}

class SlidingPuzzleWidgetState extends State<SlidingPuzzleWidget> {
  late SlidingBoard _board;
  int _moves = 0;
  bool _isAutoSolving = false;
  String _solverStatus = '';

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  @override
  void didUpdateWidget(SlidingPuzzleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAutoSolveRequested && !oldWidget.isAutoSolveRequested && !_isAutoSolving) {
      triggerAutoSolve();
    }
  }

  void _resetGame() {
    setState(() {
      _board = SlidingBoard.createSolvableBoard(widget.size, widget.scrambleSteps);
      _moves = 0;
      _isAutoSolving = false;
      _solverStatus = '';
    });
  }

  void _onTileTap(int index) {
    if (_isAutoSolving) return;

    final row = index ~/ widget.size;
    final col = index % widget.size;
    final emptyRow = _board.emptyIndex ~/ widget.size;
    final emptyCol = _board.emptyIndex % widget.size;

    // Check if adjacent
    final isAdjacent = (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);

    if (isAdjacent) {
      final newTiles = List<int>.from(_board.tiles);
      newTiles[_board.emptyIndex] = newTiles[index];
      newTiles[index] = 0;

      setState(() {
        _board = SlidingBoard(
          size: widget.size,
          tiles: List<int>.unmodifiable(newTiles),
          emptyIndex: index,
        );
        _moves++;
      });

      if (_board.isSolved) {
        widget.onSolved();
      }
    }
  }

  Future<void> triggerAutoSolve() async {
    setState(() {
      _isAutoSolving = true;
      _solverStatus = 'Computing A* heuristic path...';
    });

    final solver = AStarSolver<SlidingBoard>(
      getNeighbors: (b) => b.getNeighbors(),
      getMoveCost: (_, _) => 1.0,
      heuristic: (b) => b.manhattanDistance,
      isGoal: (b) => b.isSolved,
      keyExtractor: (b) => b.tiles.join(','),
      maxExplored: 40000,
    );

    final result = solver.search(_board);

    if (!result.isFound) {
      setState(() {
        _isAutoSolving = false;
        _solverStatus = 'Search depth limit reached. Try fewer scramble steps.';
      });
      return;
    }

    setState(() {
      _solverStatus = 'A* found solution in ${result.path.length - 1} steps (${result.nodesExplored} nodes explored). Playing back...';
    });

    // Animate moves along the path step-by-step with clear pacing
    for (int i = 1; i < result.path.length; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 650));
      setState(() {
        _board = result.path[i];
        _moves++;
      });
    }

    setState(() {
      _isAutoSolving = false;
      _solverStatus = 'A* Solution Complete!';
    });

    widget.onSolved();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = widget.size;

    return Column(
      children: [
        // Move counter & Manhattan Heuristic HUD
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Moves: $_moves',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentLavender.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'h(n) = ${_board.manhattanDistance.toInt()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.accentPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_solverStatus.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _solverStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.accentPurple, fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(height: 8),

        // Grid Board
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: size * size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final val = _board.tiles[index];
                if (val == 0) {
                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => _onTileTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPurple.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$val',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Bottom Controls
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isAutoSolving ? null : _resetGame,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Scramble', maxLines: 1, overflow: TextOverflow.ellipsis),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isAutoSolving ? null : triggerAutoSolve,
                icon: const Icon(Icons.smart_toy_outlined, size: 18),
                label: const Text('Auto-Solve A*', maxLines: 1, overflow: TextOverflow.ellipsis),
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
