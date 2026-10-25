import 'dart:collection';

class BFSResult<T> {
  final List<T> path;
  final int nodesExplored;
  final Duration executionTime;
  final bool isFound;

  BFSResult({
    required this.path,
    required this.nodesExplored,
    required this.executionTime,
    required this.isFound,
  });
}

class BFSSolver<T> {
  final List<T> Function(T) getNeighbors;
  final bool Function(T) isGoal;
  final String Function(T)? keyExtractor;

  BFSSolver({
    required this.getNeighbors,
    required this.isGoal,
    this.keyExtractor,
  });

  BFSResult<T> search(T start) {
    final stopwatch = Stopwatch()..start();
    final queue = Queue<T>();
    final visited = <dynamic>{};
    final parentMap = <dynamic, T>{};

    dynamic toKey(T node) => keyExtractor != null ? keyExtractor!(node) : node;

    queue.add(start);
    visited.add(toKey(start));
    int exploredCount = 0;

    T? goalNode;

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      exploredCount++;

      if (isGoal(current)) {
        goalNode = current;
        break;
      }

      for (final neighbor in getNeighbors(current)) {
        final key = toKey(neighbor);
        if (!visited.contains(key)) {
          visited.add(key);
          parentMap[key] = current;
          queue.add(neighbor);
        }
      }
    }

    stopwatch.stop();

    if (goalNode == null) {
      return BFSResult<T>(
        path: [],
        nodesExplored: exploredCount,
        executionTime: stopwatch.elapsed,
        isFound: false,
      );
    }

    final path = <T>[];
    T? curr = goalNode;
    while (curr != null) {
      path.add(curr);
      final key = toKey(curr);
      curr = parentMap[key];
    }

    return BFSResult<T>(
      path: path.reversed.toList(),
      nodesExplored: exploredCount,
      executionTime: stopwatch.elapsed,
      isFound: true,
    );
  }
}
