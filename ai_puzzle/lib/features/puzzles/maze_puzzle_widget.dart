import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../algorithms/maze_solver.dart';

class MazePuzzleWidget extends StatefulWidget {
  final int rows;
  final int cols;
  final VoidCallback onSolved;
  final bool isAutoSolveRequested;

  const MazePuzzleWidget({
    super.key,
    this.rows = 15,
    this.cols = 15,
    required this.onSolved,
    this.isAutoSolveRequested = false,
  });

  @override
  State<MazePuzzleWidget> createState() => MazePuzzleWidgetState();
}

class MazePuzzleWidgetState extends State<MazePuzzleWidget> {
  late MazeGrid _maze;
  late MazeCell _playerPos;
  final Set<MazeCell> _userPath = {};
  List<MazeCell> _solutionPath = [];
  bool _isAutoSolving = false;
  String _solverInfo = '';

  @override
  void initState() {
    super.initState();
    _generateMaze();
  }

  @override
  void didUpdateWidget(MazePuzzleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAutoSolveRequested && !oldWidget.isAutoSolveRequested && !_isAutoSolving) {
      triggerAutoSolveBFS();
    }
  }

  void _generateMaze() {
    setState(() {
      _maze = MazeGrid.generate(widget.rows, widget.cols);
      _playerPos = _maze.start;
      _userPath.clear();
      _userPath.add(_playerPos);
      _solutionPath.clear();
      _isAutoSolving = false;
      _solverInfo = '';
    });
  }

  void _movePlayer(int dRow, int dCol) {
    if (_isAutoSolving) return;

    final target = MazeCell(_playerPos.row + dRow, _playerPos.col + dCol);
    if (_maze.isValid(target)) {
      setState(() {
        _playerPos = target;
        _userPath.add(target);
      });

      if (_playerPos == _maze.end) {
        widget.onSolved();
      }
    }
  }

  Future<void> triggerAutoSolveBFS() async {
    setState(() {
      _isAutoSolving = true;
      _solverInfo = 'Running BFS to discover shortest path...';
    });

    final res = _maze.solveBFS();
    if (!res.isFound) return;

    setState(() {
      _solverInfo = 'BFS Path: ${res.path.length} steps | Explored ${res.nodesExplored} nodes in ${res.executionTime.inMicroseconds}µs';
      _solutionPath = res.path;
    });

    for (final cell in res.path) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _playerPos = cell;
      });
    }

    setState(() {
      _isAutoSolving = false;
    });

    widget.onSolved();
  }

  Future<void> triggerAutoSolveAStar() async {
    setState(() {
      _isAutoSolving = true;
      _solverInfo = 'Running A* with Manhattan distance heuristic...';
    });

    final res = _maze.solveAStar();
    if (!res.isFound) return;

    setState(() {
      _solverInfo = 'A* Path: ${res.path.length} steps | Explored ${res.nodesExplored} nodes (Heuristic Guided)';
      _solutionPath = res.path;
    });

    for (final cell in res.path) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _playerPos = cell;
      });
    }

    setState(() {
      _isAutoSolving = false;
    });

    widget.onSolved();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        if (_solverInfo.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              _solverInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accentPurple),
            ),
          ),
        const SizedBox(height: 8),

        // Interactive Maze Board
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: List.generate(_maze.rows, (r) {
                return Expanded(
                  child: Row(
                    children: List.generate(_maze.cols, (c) {
                      final cell = MazeCell(r, c);
                      final isWall = _maze.grid[r][c] == 1;
                      final isStart = cell == _maze.start;
                      final isEnd = cell == _maze.end;
                      final isPlayer = cell == _playerPos;
                      final isSolution = _solutionPath.contains(cell);
                      final isUserPath = _userPath.contains(cell);

                      Color color;
                      if (isPlayer) {
                        color = Colors.amber;
                      } else if (isStart) {
                        color = AppColors.success;
                      } else if (isEnd) {
                        color = AppColors.error;
                      } else if (isSolution) {
                        color = AppColors.accentPurple.withValues(alpha: 0.6);
                      } else if (isUserPath) {
                        color = AppColors.accentLavender;
                      } else if (isWall) {
                        color = isDark ? const Color(0xFF1E293B) : const Color(0xFF27272A);
                      } else {
                        color = Colors.transparent;
                      }

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(0.5),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(isPlayer ? 8 : 2),
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
        const SizedBox(height: 16),

        // Directional Controls Pad
        Column(
          children: [
            IconButton.filled(
              onPressed: () => _movePlayer(-1, 0),
              icon: const Icon(Icons.keyboard_arrow_up),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () => _movePlayer(0, -1),
                  icon: const Icon(Icons.keyboard_arrow_left),
                ),
                const SizedBox(width: 48),
                IconButton.filled(
                  onPressed: () => _movePlayer(0, 1),
                  icon: const Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
            IconButton.filled(
              onPressed: () => _movePlayer(1, 0),
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Algorithm Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isAutoSolving ? null : triggerAutoSolveBFS,
                icon: const Icon(Icons.route, size: 16),
                label: const Text('BFS Solve', maxLines: 1, overflow: TextOverflow.ellipsis),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isAutoSolving ? null : triggerAutoSolveAStar,
                icon: const Icon(Icons.star, size: 16),
                label: const Text('A* Solve', maxLines: 1, overflow: TextOverflow.ellipsis),
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
