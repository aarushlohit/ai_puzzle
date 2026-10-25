import 'dart:math';
import 'bfs_solver.dart';
import 'dfs_solver.dart';
import 'astar_solver.dart';

class MazeCell {
  final int row;
  final int col;
  const MazeCell(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MazeCell && row == other.row && col == other.col;

  @override
  int get hashCode => 31 * row + col;

  @override
  String toString() => '($row,$col)';
}

class MazeGrid {
  final int rows;
  final int cols;
  final List<List<int>> grid; // 0 = path/open, 1 = wall
  final MazeCell start;
  final MazeCell end;

  MazeGrid({
    required this.rows,
    required this.cols,
    required this.grid,
    required this.start,
    required this.end,
  });

  bool isValid(MazeCell cell) {
    return cell.row >= 0 &&
        cell.row < rows &&
        cell.col >= 0 &&
        cell.col < cols &&
        grid[cell.row][cell.col] == 0;
  }

  List<MazeCell> getNeighbors(MazeCell cell) {
    final neighbors = <MazeCell>[];
    final dirs = [
      [-1, 0], // Up
      [1, 0],  // Down
      [0, -1], // Left
      [0, 1],  // Right
    ];
    for (final d in dirs) {
      final neighbor = MazeCell(cell.row + d[0], cell.col + d[1]);
      if (isValid(neighbor)) {
        neighbors.add(neighbor);
      }
    }
    return neighbors;
  }

  // Generate a random maze using randomized recursive backtracking (DFS carve)
  static MazeGrid generate(int rows, int cols) {
    // Ensure odd dimensions for clear walls and corridors
    final actualRows = rows % 2 == 0 ? rows + 1 : rows;
    final actualCols = cols % 2 == 0 ? cols + 1 : cols;

    final grid = List.generate(actualRows, (_) => List.filled(actualCols, 1));
    final random = Random();

    void carve(int r, int c) {
      grid[r][c] = 0;
      final directions = [
        [-2, 0], // Up
        [2, 0],  // Down
        [0, -2], // Left
        [0, 2],  // Right
      ]..shuffle(random);

      for (final dir in directions) {
        final nr = r + dir[0];
        final nc = c + dir[1];
        if (nr > 0 && nr < actualRows - 1 && nc > 0 && nc < actualCols - 1 && grid[nr][nc] == 1) {
          // Carve wall between
          grid[r + dir[0] ~/ 2][c + dir[1] ~/ 2] = 0;
          carve(nr, nc);
        }
      }
    }

    carve(1, 1);

    final start = const MazeCell(1, 1);
    final end = MazeCell(actualRows - 2, actualCols - 2);
    grid[end.row][end.col] = 0;

    return MazeGrid(
      rows: actualRows,
      cols: actualCols,
      grid: grid,
      start: start,
      end: end,
    );
  }

  // Solve using BFS
  BFSResult<MazeCell> solveBFS() {
    final solver = BFSSolver<MazeCell>(
      getNeighbors: getNeighbors,
      isGoal: (cell) => cell == end,
      keyExtractor: (cell) => '${cell.row},${cell.col}',
    );
    return solver.search(start);
  }

  // Solve using DFS
  DFSResult<MazeCell> solveDFS() {
    final solver = DFSSolver<MazeCell>(
      getNeighbors: getNeighbors,
      isGoal: (cell) => cell == end,
      keyExtractor: (cell) => '${cell.row},${cell.col}',
    );
    return solver.search(start);
  }

  // Solve using A* with Manhattan distance heuristic
  AStarResult<MazeCell> solveAStar() {
    final solver = AStarSolver<MazeCell>(
      getNeighbors: getNeighbors,
      getMoveCost: (_, _) => 1.0,
      heuristic: (cell) => (cell.row - end.row).abs().toDouble() + (cell.col - end.col).abs().toDouble(),
      isGoal: (cell) => cell == end,
      keyExtractor: (cell) => '${cell.row},${cell.col}',
    );
    return solver.search(start);
  }
}
