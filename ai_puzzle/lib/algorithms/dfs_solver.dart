class DFSResult<T> {
  final List<T> path;
  final int nodesExplored;
  final Duration executionTime;
  final bool isFound;

  DFSResult({
    required this.path,
    required this.nodesExplored,
    required this.executionTime,
    required this.isFound,
  });
}

class DFSSolver<T> {
  final List<T> Function(T) getNeighbors;
  final bool Function(T) isGoal;
  final String Function(T)? keyExtractor;
  final int maxDepth;

  DFSSolver({
    required this.getNeighbors,
    required this.isGoal,
    this.keyExtractor,
    this.maxDepth = 1000,
  });

  DFSResult<T> search(T start) {
    final stopwatch = Stopwatch()..start();
    final stack = <T>[];
    final visited = <dynamic>{};
    final parentMap = <dynamic, T>{};

    dynamic toKey(T node) => keyExtractor != null ? keyExtractor!(node) : node;

    stack.add(start);
    int exploredCount = 0;
    T? goalNode;

    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      final currentKey = toKey(current);

      if (visited.contains(currentKey)) continue;
      visited.add(currentKey);
      exploredCount++;

      if (isGoal(current)) {
        goalNode = current;
        break;
      }

      for (final neighbor in getNeighbors(current)) {
        final neighborKey = toKey(neighbor);
        if (!visited.contains(neighborKey)) {
          parentMap[neighborKey] = current;
          stack.add(neighbor);
        }
      }
    }

    stopwatch.stop();

    if (goalNode == null) {
      return DFSResult<T>(
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

    return DFSResult<T>(
      path: path.reversed.toList(),
      nodesExplored: exploredCount,
      executionTime: stopwatch.elapsed,
      isFound: true,
    );
  }
}
