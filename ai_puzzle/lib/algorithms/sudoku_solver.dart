import 'dart:math';

class SudokuStep {
  final int row;
  final int col;
  final int value;
  final bool isBacktrack;

  SudokuStep({
    required this.row,
    required this.col,
    required this.value,
    this.isBacktrack = false,
  });
}

class SudokuSolverResult {
  final List<List<int>> solvedGrid;
  final bool isSolvable;
  final int stepsCount;
  final Duration executionTime;
  final List<SudokuStep> traceSteps;

  SudokuSolverResult({
    required this.solvedGrid,
    required this.isSolvable,
    required this.stepsCount,
    required this.executionTime,
    required this.traceSteps,
  });
}

class SudokuSolver {
  // Validate if placing 'val' at (row, col) in 'grid' is valid
  static bool isValidPlacement(List<List<int>> grid, int row, int col, int val) {
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] == val) return false;
    }
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == val) return false;
    }
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (grid[boxRow + r][boxCol + c] == val) return false;
      }
    }
    return true;
  }

  // Solves the grid using recursive backtracking with optional trace logging
  static SudokuSolverResult solve(List<List<int>> initialGrid, {bool recordTrace = false, int maxTrace = 500}) {
    final stopwatch = Stopwatch()..start();
    final grid = initialGrid.map((r) => List<int>.from(r)).toList();
    final trace = <SudokuStep>[];
    int stepCount = 0;

    bool backtrack(int row, int col) {
      if (row == 9) return true; // Reached past the last row
      final nextRow = col == 8 ? row + 1 : row;
      final nextCol = col == 8 ? 0 : col + 1;

      if (grid[row][col] != 0) {
        return backtrack(nextRow, nextCol);
      }

      for (int num = 1; num <= 9; num++) {
        stepCount++;
        if (isValidPlacement(grid, row, col, num)) {
          grid[row][col] = num;
          if (recordTrace && trace.length < maxTrace) {
            trace.add(SudokuStep(row: row, col: col, value: num, isBacktrack: false));
          }

          if (backtrack(nextRow, nextCol)) {
            return true;
          }

          // Backtrack
          grid[row][col] = 0;
          if (recordTrace && trace.length < maxTrace) {
            trace.add(SudokuStep(row: row, col: col, value: 0, isBacktrack: true));
          }
        }
      }

      return false;
    }

    final success = backtrack(0, 0);
    stopwatch.stop();

    return SudokuSolverResult(
      solvedGrid: grid,
      isSolvable: success,
      stepsCount: stepCount,
      executionTime: stopwatch.elapsed,
      traceSteps: trace,
    );
  }

  // Count number of solutions (stops after 2 to verify uniqueness)
  static int countSolutions(List<List<int>> initialGrid, {int limit = 2}) {
    final grid = initialGrid.map((r) => List<int>.from(r)).toList();
    int count = 0;

    void backtrack(int row, int col) {
      if (row == 9) {
        count++;
        return;
      }
      final nextRow = col == 8 ? row + 1 : row;
      final nextCol = col == 8 ? 0 : col + 1;

      if (grid[row][col] != 0) {
        backtrack(nextRow, nextCol);
        return;
      }

      for (int num = 1; num <= 9; num++) {
        if (isValidPlacement(grid, row, col, num)) {
          grid[row][col] = num;
          backtrack(nextRow, nextCol);
          grid[row][col] = 0;
          if (count >= limit) return;
        }
      }
    }

    backtrack(0, 0);
    return count;
  }

  // Generate a valid solved board and then carve clues based on difficulty
  static Map<String, dynamic> generateSudoku(String difficulty) {
    // 1. Generate full solved board
    final fullGrid = List.generate(9, (_) => List.filled(9, 0));
    _fillGridRandomly(fullGrid);

    final solutionGrid = fullGrid.map((r) => List<int>.from(r)).toList();

    // 2. Determine number of clues to keep
    int cluesCount;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        cluesCount = 42;
        break;
      case 'medium':
        cluesCount = 34;
        break;
      case 'hard':
        cluesCount = 28;
        break;
      case 'expert':
        cluesCount = 24;
        break;
      case 'insane':
        cluesCount = 21;
        break;
      default:
        cluesCount = 32;
    }

    // 3. Remove cells while preserving uniqueness
    final puzzleGrid = solutionGrid.map((r) => List<int>.from(r)).toList();
    final random = Random();
    final positions = <List<int>>[];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        positions.add([r, c]);
      }
    }
    positions.shuffle(random);

    int removed = 0;
    int targetRemove = 81 - cluesCount;

    for (final pos in positions) {
      if (removed >= targetRemove) break;
      final r = pos[0];
      final c = pos[1];
      final temp = puzzleGrid[r][c];
      puzzleGrid[r][c] = 0;

      // Check if uniqueness is maintained
      if (countSolutions(puzzleGrid, limit: 2) == 1) {
        removed++;
      } else {
        puzzleGrid[r][c] = temp; // Restore
      }
    }

    return {
      'puzzle': puzzleGrid,
      'solution': solutionGrid,
    };
  }

  static bool _fillGridRandomly(List<List<int>> grid) {
    final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    final random = Random();

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == 0) {
          numbers.shuffle(random);
          for (final num in numbers) {
            if (isValidPlacement(grid, r, c, num)) {
              grid[r][c] = num;
              if (_fillGridRandomly(grid)) return true;
              grid[r][c] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }
}
