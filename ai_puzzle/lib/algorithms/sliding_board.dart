import 'dart:math';

class SlidingBoard {
  final int size; // 3 for 3x3, 4 for 4x4
  final List<int> tiles; // 0 represents the empty space
  final int emptyIndex;

  SlidingBoard({
    required this.size,
    required this.tiles,
    required this.emptyIndex,
  });

  factory SlidingBoard.createGoal(int size) {
    final tiles = <int>[];
    for (int i = 1; i < size * size; i++) {
      tiles.add(i);
    }
    tiles.add(0); // empty slot at the end
    return SlidingBoard(
      size: size,
      tiles: tiles,
      emptyIndex: size * size - 1,
    );
  }

  factory SlidingBoard.fromList(int size, List<int> list) {
    final emptyIdx = list.indexOf(0);
    return SlidingBoard(
      size: size,
      tiles: List<int>.unmodifiable(list),
      emptyIndex: emptyIdx,
    );
  }

  bool get isSolved {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }

  // Manhattan distance heuristic
  double get manhattanDistance {
    double distance = 0;
    for (int i = 0; i < tiles.length; i++) {
      final value = tiles[i];
      if (value == 0) continue; // empty cell doesn't contribute
      final targetRow = (value - 1) ~/ size;
      final targetCol = (value - 1) % size;
      final currentRow = i ~/ size;
      final currentCol = i % size;
      distance += (currentRow - targetRow).abs() + (currentCol - targetCol).abs();
    }
    return distance;
  }

  List<SlidingBoard> getNeighbors() {
    final neighbors = <SlidingBoard>[];
    final row = emptyIndex ~/ size;
    final col = emptyIndex % size;

    // Possible moves: Up, Down, Left, Right for adjacent tile into empty slot
    final moves = [
      [-1, 0], // Move tile above into empty
      [1, 0],  // Move tile below into empty
      [0, -1], // Move tile left into empty
      [0, 1],  // Move tile right into empty
    ];

    for (final move in moves) {
      final newRow = row + move[0];
      final newCol = col + move[1];

      if (newRow >= 0 && newRow < size && newCol >= 0 && newCol < size) {
        final newEmptyIndex = newRow * size + newCol;
        final newTiles = List<int>.from(tiles);
        newTiles[emptyIndex] = newTiles[newEmptyIndex];
        newTiles[newEmptyIndex] = 0;
        neighbors.add(SlidingBoard(
          size: size,
          tiles: List<int>.unmodifiable(newTiles),
          emptyIndex: newEmptyIndex,
        ));
      }
    }
    return neighbors;
  }

  // Create a legal scrambled board by doing random valid moves from goal
  static SlidingBoard createSolvableBoard(int size, int scrambleSteps) {
    var board = SlidingBoard.createGoal(size);
    final random = Random();
    int lastMovedTile = -1;

    for (int step = 0; step < scrambleSteps; step++) {
      final neighbors = board.getNeighbors();
      // Avoid immediately undoing previous move
      final candidates = neighbors.where((n) {
        return n.tiles[board.emptyIndex] != lastMovedTile;
      }).toList();

      final chosen = candidates.isNotEmpty
          ? candidates[random.nextInt(candidates.length)]
          : neighbors[random.nextInt(neighbors.length)];

      lastMovedTile = board.tiles[chosen.emptyIndex];
      board = chosen;
    }
    return board;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlidingBoard &&
          size == other.size &&
          _listEquals(tiles, other.tiles);

  @override
  int get hashCode => tiles.fold(0, (prev, elem) => 31 * prev + elem.hashCode);

  static bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() => tiles.join(',');
}
