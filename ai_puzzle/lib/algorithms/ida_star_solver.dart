import 'sliding_board.dart';

class IDAStep {
  final SlidingBoard board;
  final int tileMoved;
  IDAStep(this.board, this.tileMoved);
}

class IDAResult {
  final List<SlidingBoard> path;
  final int nodesExplored;
  final Duration executionTime;
  final bool isFound;

  IDAResult({
    required this.path,
    required this.nodesExplored,
    required this.executionTime,
    required this.isFound,
  });
}

class IDASolver {
  static const double infinity = 1e9;
  int _nodesExplored = 0;

  IDAResult solve(SlidingBoard start, {int maxExplored = 100000, Duration timeout = const Duration(seconds: 4)}) {
    final stopwatch = Stopwatch()..start();
    _nodesExplored = 0;

    double threshold = start.manhattanDistance;
    final path = <SlidingBoard>[start];

    while (true) {
      if (stopwatch.elapsed > timeout || _nodesExplored > maxExplored) {
        break;
      }

      final res = _search(path, 0, threshold, stopwatch, timeout, maxExplored);
      if (res == -1) {
        // Found solution!
        stopwatch.stop();
        return IDAResult(
          path: List.from(path),
          nodesExplored: _nodesExplored,
          executionTime: stopwatch.elapsed,
          isFound: true,
        );
      }
      if (res >= infinity) {
        break; // Unsolvable or limit reached
      }
      threshold = res;
    }

    stopwatch.stop();
    return IDAResult(
      path: [],
      nodesExplored: _nodesExplored,
      executionTime: stopwatch.elapsed,
      isFound: false,
    );
  }

  double _search(
    List<SlidingBoard> path,
    double g,
    double threshold,
    Stopwatch sw,
    Duration timeout,
    int maxExplored,
  ) {
    final current = path.last;
    _nodesExplored++;

    if (sw.elapsed > timeout || _nodesExplored > maxExplored) {
      return infinity;
    }

    final f = g + current.manhattanDistance;
    if (f > threshold) return f;
    if (current.isSolved) return -1; // Flag found

    double min = infinity;

    for (final neighbor in current.getNeighbors()) {
      // Avoid cycles in current branch
      if (path.contains(neighbor)) continue;

      path.add(neighbor);
      final t = _search(path, g + 1, threshold, sw, timeout, maxExplored);
      if (t == -1) return -1;
      if (t < min) min = t;
      path.removeLast();
    }

    return min;
  }
}
