import 'package:flutter_test/flutter_test.dart';
import 'package:ai_puzzle/algorithms/bfs_solver.dart';
import 'package:ai_puzzle/algorithms/dfs_solver.dart';
import 'package:ai_puzzle/algorithms/astar_solver.dart';
import 'package:ai_puzzle/algorithms/sliding_board.dart';
import 'package:ai_puzzle/algorithms/sudoku_solver.dart';
import 'package:ai_puzzle/algorithms/maze_solver.dart';

void main() {
  group('BFS Algorithm Tests', () {
    test('Finds shortest path on linear graph', () {
      final solver = BFSSolver<int>(
        getNeighbors: (n) => [n + 1, n + 2],
        isGoal: (n) => n == 5,
      );
      final result = solver.search(1);
      expect(result.isFound, isTrue);
      expect(result.path.first, equals(1));
      expect(result.path.last, equals(5));
      // 1 -> 3 -> 5 is length 3
      expect(result.path.length, equals(3));
    });

    test('Handles unreachable goal gracefully', () {
      final solver = BFSSolver<int>(
        getNeighbors: (n) => n < 3 ? [n + 1] : [],
        isGoal: (n) => n == 10,
      );
      final result = solver.search(0);
      expect(result.isFound, isFalse);
      expect(result.path, isEmpty);
    });
  });

  group('DFS Algorithm Tests', () {
    test('Explores tree and finds target without cycles', () {
      final solver = DFSSolver<int>(
        getNeighbors: (n) => n < 10 ? [n * 2, n + 1] : [],
        isGoal: (n) => n == 7,
      );
      final result = solver.search(1);
      expect(result.isFound, isTrue);
      expect(result.path.last, equals(7));
    });
  });

  group('A* Search Algorithm Tests', () {
    test('Finds optimal path using Manhattan heuristic on SlidingBoard', () {
      // 1-move away from goal:
      // 1 2 3
      // 4 5 6
      // 7 0 8
      final board = SlidingBoard.fromList(3, [1, 2, 3, 4, 5, 6, 7, 0, 8]);
      final solver = AStarSolver<SlidingBoard>(
        getNeighbors: (b) => b.getNeighbors(),
        getMoveCost: (_, _) => 1.0,
        heuristic: (b) => b.manhattanDistance,
        isGoal: (b) => b.isSolved,
        keyExtractor: (b) => b.tiles.join(','),
      );

      final result = solver.search(board);
      expect(result.isFound, isTrue);
      expect(result.path.length, equals(2)); // start state -> goal state
      expect(result.path.last.isSolved, isTrue);
    });

    test('Already solved board returns path length 1', () {
      final goal = SlidingBoard.createGoal(3);
      final solver = AStarSolver<SlidingBoard>(
        getNeighbors: (b) => b.getNeighbors(),
        getMoveCost: (_, _) => 1.0,
        heuristic: (b) => b.manhattanDistance,
        isGoal: (b) => b.isSolved,
      );
      final result = solver.search(goal);
      expect(result.isFound, isTrue);
      expect(result.path.length, equals(1));
    });
  });

  group('Sliding Board Mechanics', () {
    test('Generates solvable scramble with valid moves', () {
      final board = SlidingBoard.createSolvableBoard(3, 10);
      expect(board.tiles.length, equals(9));
      expect(board.tiles.contains(0), isTrue);
      final neighbors = board.getNeighbors();
      expect(neighbors.isNotEmpty, isTrue);
    });
  });

  group('Sudoku Backtracking Solver Tests', () {
    test('Validates placement rules', () {
      final grid = List.generate(9, (_) => List.filled(9, 0));
      grid[0][0] = 5;
      expect(SudokuSolver.isValidPlacement(grid, 0, 5, 5), isFalse); // same row
      expect(SudokuSolver.isValidPlacement(grid, 5, 0, 5), isFalse); // same col
      expect(SudokuSolver.isValidPlacement(grid, 1, 1, 5), isFalse); // same 3x3 box
      expect(SudokuSolver.isValidPlacement(grid, 4, 4, 5), isTrue);  // valid
    });

    test('Solves valid puzzle configuration', () {
      final generated = SudokuSolver.generateSudoku('easy');
      final puzzle = generated['puzzle'] as List<List<int>>;
      final result = SudokuSolver.solve(puzzle);
      expect(result.isSolvable, isTrue);
      expect(result.solvedGrid.length, equals(9));
      for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
          expect(result.solvedGrid[r][c], inInclusiveRange(1, 9));
        }
      }
    });
  });

  group('Maze Solver Tests', () {
    test('Generates connected maze and finds path with BFS and A*', () {
      final maze = MazeGrid.generate(11, 11);
      final bfsRes = maze.solveBFS();
      final astarRes = maze.solveAStar();

      expect(bfsRes.isFound, isTrue);
      expect(astarRes.isFound, isTrue);
      expect(bfsRes.path.first, equals(maze.start));
      expect(bfsRes.path.last, equals(maze.end));
      expect(astarRes.path.last, equals(maze.end));
    });
  });
}
