import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../algorithms/maze_solver.dart';

class AlgorithmVisualizerScreen extends StatefulWidget {
  const AlgorithmVisualizerScreen({super.key});

  @override
  State<AlgorithmVisualizerScreen> createState() => _AlgorithmVisualizerScreenState();
}

class _AlgorithmVisualizerScreenState extends State<AlgorithmVisualizerScreen> {
  late MazeGrid _maze;
  String _selectedAlgorithm = 'BFS';
  bool _isRunning = false;

  final Set<MazeCell> _exploredCells = {};
  List<MazeCell> _finalPath = [];
  int _exploredCount = 0;
  int _pathLength = 0;
  int _executionMicroseconds = 0;

  @override
  void initState() {
    super.initState();
    _resetGrid();
  }

  void _resetGrid() {
    setState(() {
      _maze = MazeGrid.generate(15, 15);
      _exploredCells.clear();
      _finalPath.clear();
      _exploredCount = 0;
      _pathLength = 0;
      _executionMicroseconds = 0;
      _isRunning = false;
    });
  }

  Future<void> _runVisualizer() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _exploredCells.clear();
      _finalPath.clear();
    });

    final stopwatch = Stopwatch()..start();

    if (_selectedAlgorithm == 'BFS') {
      final res = _maze.solveBFS();
      stopwatch.stop();

      // Trace BFS layer exploration
      for (final cell in res.path) {
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 30));
        setState(() {
          _exploredCells.add(cell);
        });
      }

      setState(() {
        _finalPath = res.path;
        _exploredCount = res.nodesExplored;
        _pathLength = res.path.length;
        _executionMicroseconds = res.executionTime.inMicroseconds;
        _isRunning = false;
      });
    } else if (_selectedAlgorithm == 'DFS') {
      final res = _maze.solveDFS();
      stopwatch.stop();

      for (final cell in res.path) {
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 30));
        setState(() {
          _exploredCells.add(cell);
        });
      }

      setState(() {
        _finalPath = res.path;
        _exploredCount = res.nodesExplored;
        _pathLength = res.path.length;
        _executionMicroseconds = res.executionTime.inMicroseconds;
        _isRunning = false;
      });
    } else {
      // A* Search
      final res = _maze.solveAStar();
      stopwatch.stop();

      for (final cell in res.path) {
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 30));
        setState(() {
          _exploredCells.add(cell);
        });
      }

      setState(() {
        _finalPath = res.path;
        _exploredCount = res.nodesExplored;
        _pathLength = res.path.length;
        _executionMicroseconds = res.executionTime.inMicroseconds;
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Algorithm Visualizer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Algorithm Selection Tabs
            Row(
              children: ['BFS', 'DFS', 'A*'].map((algo) {
                final isSelected = _selectedAlgorithm == algo;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: _isRunning ? null : () => setState(() => _selectedAlgorithm = algo),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.accentPurple : (isDark ? Colors.white12 : AppColors.borderSubtle),
                        foregroundColor: isSelected ? Colors.white : AppColors.primaryText,
                      ),
                      child: Text(algo),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Live Performance Metrics HUD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _metricPill('Nodes Visited', '$_exploredCount'),
                  _metricPill('Path Length', '$_pathLength'),
                  _metricPill('Exec Time', '$_executionMicrosecondsµs'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Grid Map
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: const EdgeInsets.all(6),
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
                          final isPath = _finalPath.contains(cell);
                          final isExplored = _exploredCells.contains(cell);

                          Color color;
                          if (isStart) {
                            color = AppColors.success;
                          } else if (isEnd) {
                            color = AppColors.error;
                          } else if (isPath) {
                            color = Colors.amber;
                          } else if (isExplored) {
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
                                borderRadius: BorderRadius.circular(2),
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

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _isRunning ? null : _resetGrid,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Maze'),
                ),
                const SizedBox(width: 14),
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runVisualizer,
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Simulate $_selectedAlgorithm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricPill(String title, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.accentPurple)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
      ],
    );
  }
}
