
class AStarNode<T> implements Comparable<AStarNode<T>> {
  final T state;
  final double gCost; // Cost from start
  final double hCost; // Heuristic estimate to goal
  double get fCost => gCost + hCost;
  final AStarNode<T>? parent;

  AStarNode({
    required this.state,
    required this.gCost,
    required this.hCost,
    this.parent,
  });

  @override
  int compareTo(AStarNode<T> other) {
    if (fCost < other.fCost) return -1;
    if (fCost > other.fCost) return 1;
    // Tie breaking on hCost
    if (hCost < other.hCost) return -1;
    if (hCost > other.hCost) return 1;
    return 0;
  }
}

class AStarResult<T> {
  final List<T> path;
  final int nodesExplored;
  final Duration executionTime;
  final bool isFound;
  final double cost;

  AStarResult({
    required this.path,
    required this.nodesExplored,
    required this.executionTime,
    required this.isFound,
    required this.cost,
  });
}

class AStarSolver<T> {
  final List<T> Function(T) getNeighbors;
  final double Function(T, T) getMoveCost;
  final double Function(T) heuristic;
  final bool Function(T) isGoal;
  final String Function(T)? keyExtractor;
  final int maxExplored;

  AStarSolver({
    required this.getNeighbors,
    required this.getMoveCost,
    required this.heuristic,
    required this.isGoal,
    this.keyExtractor,
    this.maxExplored = 50000,
  });

  AStarResult<T> search(T start) {
    final stopwatch = Stopwatch()..start();
    dynamic toKey(T node) => keyExtractor != null ? keyExtractor!(node) : node;

    // Open set priority list (min-heap simulation using binary search insertion or sorted list)
    final openList = <AStarNode<T>>[];
    final openSetKeys = <dynamic, double>{}; // key -> best gCost in open
    final closedSetKeys = <dynamic, double>{}; // key -> best gCost in closed

    final startNode = AStarNode<T>(
      state: start,
      gCost: 0,
      hCost: heuristic(start),
      parent: null,
    );

    openList.add(startNode);
    openSetKeys[toKey(start)] = 0;

    int exploredCount = 0;
    AStarNode<T>? goalNode;

    while (openList.isNotEmpty && exploredCount < maxExplored) {
      // Pop node with lowest fCost
      final current = openList.removeAt(0);
      final currentKey = toKey(current.state);
      openSetKeys.remove(currentKey);

      exploredCount++;

      if (isGoal(current.state)) {
        goalNode = current;
        break;
      }

      closedSetKeys[currentKey] = current.gCost;

      for (final neighbor in getNeighbors(current.state)) {
        final neighborKey = toKey(neighbor);
        final stepCost = getMoveCost(current.state, neighbor);
        final tentativeG = current.gCost + stepCost;

        if (closedSetKeys.containsKey(neighborKey) && tentativeG >= closedSetKeys[neighborKey]!) {
          continue;
        }

        final inOpen = openSetKeys.containsKey(neighborKey);
        if (!inOpen || tentativeG < openSetKeys[neighborKey]!) {
          final h = heuristic(neighbor);
          final neighborNode = AStarNode<T>(
            state: neighbor,
            gCost: tentativeG,
            hCost: h,
            parent: current,
          );

          if (inOpen) {
            openList.removeWhere((n) => toKey(n.state) == neighborKey);
          }

          // Insert into sorted openList
          int index = openList.indexWhere((n) => n.compareTo(neighborNode) > 0);
          if (index == -1) {
            openList.add(neighborNode);
          } else {
            openList.insert(index, neighborNode);
          }

          openSetKeys[neighborKey] = tentativeG;
        }
      }
    }

    stopwatch.stop();

    if (goalNode == null) {
      return AStarResult<T>(
        path: [],
        nodesExplored: exploredCount,
        executionTime: stopwatch.elapsed,
        isFound: false,
        cost: 0,
      );
    }

    final path = <T>[];
    AStarNode<T>? curr = goalNode;
    while (curr != null) {
      path.add(curr.state);
      curr = curr.parent;
    }

    return AStarResult<T>(
      path: path.reversed.toList(),
      nodesExplored: exploredCount,
      executionTime: stopwatch.elapsed,
      isFound: true,
      cost: goalNode.gCost,
    );
  }
}
