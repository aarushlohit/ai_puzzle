import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/puzzle_model.dart';
import '../../algorithms/math_generator.dart';

class PuzzleRepository {
  final Map<PuzzleCategory, List<PuzzleModel>> _cache = {};

  Future<void> loadAll() async {
    for (final category in PuzzleCategory.values) {
      await getPuzzlesForCategory(category);
    }
  }

  Future<List<PuzzleModel>> getPuzzlesForCategory(PuzzleCategory category) async {
    if (_cache.containsKey(category) && _cache[category]!.isNotEmpty) {
      return _cache[category]!;
    }

    final list = <PuzzleModel>[];

    // Authored JSON assets
    final assetNames = {
      PuzzleCategory.animals: 'animals.json',
      PuzzleCategory.birds: 'birds.json',
      PuzzleCategory.gk: 'gk.json',
      PuzzleCategory.cryptography: 'cryptography.json',
      PuzzleCategory.logic: 'logic.json',
      PuzzleCategory.detective: 'detective.json',
      PuzzleCategory.chess: 'chess.json',
      PuzzleCategory.words: 'words.json',
    };

    if (assetNames.containsKey(category)) {
      try {
        final jsonStr = await rootBundle.loadString('assets/puzzles/${assetNames[category]}');
        final data = jsonDecode(jsonStr) as List<dynamic>;
        for (final item in data) {
          list.add(PuzzleModel.fromJson(item as Map<String, dynamic>));
        }
      } catch (e) {
        // Fallback or empty if not present
      }
    }

    // Dynamic / Deterministic algorithmic categories
    if (category == PuzzleCategory.mathematics) {
      list.addAll(_generateMathPuzzles());
    } else if (category == PuzzleCategory.sliding) {
      list.addAll(_generateSlidingPuzzles());
    } else if (category == PuzzleCategory.sudoku) {
      list.addAll(_generateSudokuPuzzles());
    } else if (category == PuzzleCategory.maze) {
      list.addAll(_generateMazePuzzles());
    } else if (category == PuzzleCategory.patterns) {
      list.addAll(_generatePatternPuzzles());
    } else if (category == PuzzleCategory.memory) {
      list.addAll(_generateMemoryPuzzles());
    } else if (category == PuzzleCategory.mixed) {
      list.addAll(_generateMixedPuzzles());
    }

    _cache[category] = list;
    return list;
  }

  List<PuzzleModel> _generateMathPuzzles() {
    final list = <PuzzleModel>[];
    final difficulties = [
      PuzzleDifficulty.easy,
      PuzzleDifficulty.medium,
      PuzzleDifficulty.hard,
      PuzzleDifficulty.expert,
      PuzzleDifficulty.insane,
    ];

    int idx = 1;
    for (final diff in difficulties) {
      final gen = MathGenerator.generateSequence(diff.name);
      list.add(PuzzleModel(
        id: 'math_${idx.toString().padLeft(2, '0')}',
        category: PuzzleCategory.mathematics,
        title: 'Sequence Mastery (${diff.displayName})',
        description: gen['question'] as String,
        difficulty: diff,
        puzzleData: gen,
        validAnswers: [gen['answer'] as String],
        hintLadder: HintLadder(
          gentle: gen['gentle'] as String,
          guided: gen['guided'] as String,
          strong: gen['strong'] as String,
          fullSolution: gen['answer'] as String,
        ),
        explanation: gen['explanation'] as String,
      ));
      idx++;
    }

    // Add Bayesian reasoning puzzle (Academic CO4)
    final bayes = MathGenerator.generateBayesPuzzle();
    list.add(PuzzleModel(
      id: 'math_bayes_01',
      category: PuzzleCategory.mathematics,
      title: bayes['title'] as String,
      description: bayes['scenario'] as String,
      difficulty: PuzzleDifficulty.expert,
      puzzleData: bayes,
      validAnswers: [bayes['answer'] as String, '9.17', '9.2%'],
      hintLadder: HintLadder(
        gentle: bayes['gentle'] as String,
        guided: bayes['guided'] as String,
        strong: bayes['strong'] as String,
        fullSolution: bayes['answer'] as String,
      ),
      explanation: bayes['explanation'] as String,
      estimatedSeconds: 120,
    ));

    return list;
  }

  List<PuzzleModel> _generateSlidingPuzzles() {
    return [
      PuzzleModel(
        id: 'slide_3x3_easy',
        category: PuzzleCategory.sliding,
        title: '3x3 Sprint',
        description: 'Slide the tiles into natural numerical order (1 through 8) with the empty space in the bottom-right.',
        difficulty: PuzzleDifficulty.easy,
        puzzleData: {'size': 3, 'scramble': 6},
        validAnswers: ['1,2,3,4,5,6,7,8,0'],
        hintLadder: HintLadder(
          gentle: 'Work on placing 1 and 2 in the top row first.',
          guided: 'Position the top row, then solve the remaining rows layer by layer.',
          strong: 'Use Manhattan distance heuristics to guide the lowest cost tile swaps.',
          fullSolution: '1,2,3,4,5,6,7,8,0',
        ),
        explanation: 'A* with Manhattan distance heuristic calculates optimal slide transitions.',
      ),
      PuzzleModel(
        id: 'slide_3x3_hard',
        category: PuzzleCategory.sliding,
        title: '3x3 Deep Scramble',
        description: 'A heavily scrambled 8-puzzle requiring multi-step A* path search.',
        difficulty: PuzzleDifficulty.hard,
        puzzleData: {'size': 3, 'scramble': 18},
        validAnswers: ['1,2,3,4,5,6,7,8,0'],
        hintLadder: HintLadder(
          gentle: 'Avoid moving solved top-row tiles back out of place.',
          guided: 'Focus on corner-edge pairings for 7 and 8 in the bottom row.',
          strong: 'Check which adjacent tile reduces overall Manhattan distance.',
          fullSolution: '1,2,3,4,5,6,7,8,0',
        ),
        explanation: 'Solved via pure Dart A* graph search exploring legal tile configurations.',
      ),
      PuzzleModel(
        id: 'slide_4x4_expert',
        category: PuzzleCategory.sliding,
        title: '15-Puzzle Grandmaster',
        description: 'Classic 4x4 15-puzzle. High state complexity (16!/2 reachable states).',
        difficulty: PuzzleDifficulty.expert,
        puzzleData: {'size': 4, 'scramble': 14},
        validAnswers: ['1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0'],
        hintLadder: HintLadder(
          gentle: 'Solve row 1 (1-4) completely, then treat remaining board as 3x4.',
          guided: 'Iterative Deepening A* (IDA*) controls exponential memory growth for 4x4.',
          strong: 'Focus on establishing the left column (5, 9, 13).',
          fullSolution: '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0',
        ),
        explanation: '4x4 board state evaluated using IDA* heuristic search.',
      ),
    ];
  }

  List<PuzzleModel> _generateSudokuPuzzles() {
    return [
      PuzzleModel(
        id: 'sudoku_easy_01',
        category: PuzzleCategory.sudoku,
        title: 'Gentle Grid',
        description: 'Fill in numbers 1 through 9 such that each row, column, and 3x3 box contains all digits.',
        difficulty: PuzzleDifficulty.easy,
        puzzleData: {'difficulty': 'easy'},
        validAnswers: ['solved'],
        hintLadder: HintLadder(
          gentle: 'Look for rows or columns with only 1 or 2 missing numbers.',
          guided: 'Scan the 3x3 boxes for the number with the most occurrences.',
          strong: 'Check row 1 or box 1 for naked singles.',
          fullSolution: 'Validated unique 9x9 solution',
        ),
        explanation: 'Solved using constraint satisfaction and depth-first backtracking.',
      ),
      PuzzleModel(
        id: 'sudoku_hard_01',
        category: PuzzleCategory.sudoku,
        title: 'Challenger Matrix',
        description: 'Minimal clues requiring multi-level inference and candidate elimination.',
        difficulty: PuzzleDifficulty.hard,
        puzzleData: {'difficulty': 'hard'},
        validAnswers: ['solved'],
        hintLadder: HintLadder(
          gentle: 'Use pencil marks to track candidate notes for each empty cell.',
          guided: 'Look for hidden pairs in column 5 and box 7.',
          strong: 'A backtracking agent tests valid candidates recursively.',
          fullSolution: 'Complete grid generated and verified',
        ),
        explanation: 'Solved via recursive backtracking with forward checking.',
      ),
    ];
  }

  List<PuzzleModel> _generateMazePuzzles() {
    return [
      PuzzleModel(
        id: 'maze_classic_01',
        category: PuzzleCategory.maze,
        title: 'The Labyrinth',
        description: 'Navigate from the green start cell (top-left) to the red goal cell (bottom-right).',
        difficulty: PuzzleDifficulty.easy,
        puzzleData: {'rows': 15, 'cols': 15},
        validAnswers: ['goal_reached'],
        hintLadder: HintLadder(
          gentle: 'Follow the open corridors without hitting dead ends.',
          guided: 'BFS guarantees the shortest path in unweighted 2D mazes.',
          strong: 'Head down-right through the main central arterial path.',
          fullSolution: 'Shortest path found by Breadth-First Search',
        ),
        explanation: 'BFS and A* pathfinding explore valid adjacent coordinates to construct the optimal route.',
      ),
      PuzzleModel(
        id: 'maze_expert_01',
        category: PuzzleCategory.maze,
        title: 'Minotaur Complex',
        description: 'A dense, highly branched maze generated by randomized recursive backtracking.',
        difficulty: PuzzleDifficulty.expert,
        puzzleData: {'rows': 21, 'cols': 21},
        validAnswers: ['goal_reached'],
        hintLadder: HintLadder(
          gentle: 'A* uses Manhattan distance to prioritize exploration towards the exit.',
          guided: 'Avoid exploring long dead-end corridors on the upper-right flank.',
          strong: 'Branch south towards row 10.',
          fullSolution: 'Verified path discovered via A* search',
        ),
        explanation: 'High branching maze demonstrating search efficiency comparison between BFS, DFS, and A*.',
      ),
    ];
  }

  List<PuzzleModel> _generatePatternPuzzles() {
    return [
      PuzzleModel(
        id: 'pat_01',
        category: PuzzleCategory.patterns,
        title: 'Geometric Progression of Vertices',
        description: 'Identify the next shape in sequence:\nTriangle (3), Square (4), Pentagon (5), Hexagon (6), ?\nHow many sides does the next shape have?',
        difficulty: PuzzleDifficulty.easy,
        puzzleData: {'sequence': [3, 4, 5, 6]},
        validAnswers: ['7', 'heptagon', 'septagon'],
        hintLadder: HintLadder(
          gentle: 'Count the number of vertices or edges.',
          guided: 'Each polygon adds 1 additional edge: 3, 4, 5, 6.',
          strong: 'Add 1 to 6.',
          fullSolution: '7 (Heptagon)',
        ),
        explanation: 'Regular polygons with number of vertices increasing monotonically: n + 1.',
      ),
      PuzzleModel(
        id: 'pat_02',
        category: PuzzleCategory.patterns,
        title: 'Matrix Rotation Invariance',
        description: 'An arrow points UP, then RIGHT, then DOWN, then LEFT, then ?\nIn which direction does it point next?',
        difficulty: PuzzleDifficulty.medium,
        puzzleData: {'cycle': ['UP', 'RIGHT', 'DOWN', 'LEFT']},
        validAnswers: ['up', 'north'],
        hintLadder: HintLadder(
          gentle: 'Trace the clockwise rotation angles.',
          guided: '90-degree clockwise cycle: 0 -> 90 -> 180 -> 270 -> 360/0.',
          strong: 'Full circle completed, returning to the starting direction.',
          fullSolution: 'UP',
        ),
        explanation: 'Clockwise rotational symmetry modulo 360 degrees.',
      ),
    ];
  }

  List<PuzzleModel> _generateMemoryPuzzles() {
    return [
      PuzzleModel(
        id: 'mem_01',
        category: PuzzleCategory.memory,
        title: 'Symbol Matrix Recall',
        description: 'Memorize the grid of matching symbols and uncover all identical pairs.',
        difficulty: PuzzleDifficulty.easy,
        puzzleData: {'pairs_count': 6},
        validAnswers: ['completed'],
        hintLadder: HintLadder(
          gentle: 'Group cards by spatial quadrants in your memory.',
          guided: 'Remember recently flipped cards even when they don’t match.',
          strong: 'Check the top-left card against its match.',
          fullSolution: 'All 6 pairs matched',
        ),
        explanation: 'Cognitive memory testing visual association and spatial retention.',
      ),
    ];
  }

  List<PuzzleModel> _generateMixedPuzzles() {
    return [
      PuzzleModel(
        id: 'mix_01',
        category: PuzzleCategory.mixed,
        title: 'Turing-Archimedes Hybrid Challenge',
        description: 'A multi-part enigma:\n1. If a circle has radius 7, what is its approximate circumference? (Using Pi = 22/7, Circumference = 2*Pi*r)\nAnswer with the integer value.',
        difficulty: PuzzleDifficulty.hard,
        puzzleData: {'type': 'hybrid'},
        validAnswers: ['44'],
        hintLadder: HintLadder(
          gentle: 'Apply Archimedes formula C = 2 * Pi * r.',
          guided: 'Multiply 2 * (22/7) * 7. The 7s cancel out.',
          strong: 'Compute 2 * 22.',
          fullSolution: '44',
        ),
        explanation: 'Circumference = 2 * (22/7) * 7 = 44 units.',
      ),
    ];
  }
}
