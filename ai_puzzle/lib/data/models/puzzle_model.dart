
enum PuzzleDifficulty {
  easy,
  medium,
  hard,
  expert,
  insane;

  String get displayName {
    switch (this) {
      case PuzzleDifficulty.easy:
        return 'Easy';
      case PuzzleDifficulty.medium:
        return 'Medium';
      case PuzzleDifficulty.hard:
        return 'Hard';
      case PuzzleDifficulty.expert:
        return 'Expert';
      case PuzzleDifficulty.insane:
        return 'Insane';
    }
  }

  int get baseXP {
    switch (this) {
      case PuzzleDifficulty.easy:
        return 10;
      case PuzzleDifficulty.medium:
        return 25;
      case PuzzleDifficulty.hard:
        return 50;
      case PuzzleDifficulty.expert:
        return 100;
      case PuzzleDifficulty.insane:
        return 200;
    }
  }

  static PuzzleDifficulty fromString(String val) {
    return PuzzleDifficulty.values.firstWhere(
      (d) => d.name.toLowerCase() == val.toLowerCase(),
      orElse: () => PuzzleDifficulty.easy,
    );
  }
}

enum PuzzleCategory {
  animals,
  birds,
  gk,
  mathematics,
  sliding,
  sudoku,
  logic,
  patterns,
  words,
  maze,
  cryptography,
  memory,
  chess,
  detective,
  mixed;

  String get displayName {
    switch (this) {
      case PuzzleCategory.animals:
        return 'Animal Mysteries';
      case PuzzleCategory.birds:
        return 'Bird Intelligence';
      case PuzzleCategory.gk:
        return 'General Knowledge';
      case PuzzleCategory.mathematics:
        return 'Mathematical Puzzles';
      case PuzzleCategory.sliding:
        return 'Sliding Number Puzzle';
      case PuzzleCategory.sudoku:
        return 'Sudoku Masters';
      case PuzzleCategory.logic:
        return 'Logical Reasoning';
      case PuzzleCategory.patterns:
        return 'Pattern Recognition';
      case PuzzleCategory.words:
        return 'Word Puzzles';
      case PuzzleCategory.maze:
        return 'Maze Solver';
      case PuzzleCategory.cryptography:
        return 'Cryptography Puzzles';
      case PuzzleCategory.memory:
        return 'Memory Challenges';
      case PuzzleCategory.chess:
        return 'Chess Tactics';
      case PuzzleCategory.detective:
        return 'Detective Mysteries';
      case PuzzleCategory.mixed:
        return 'AI Mixed Challenge';
    }
  }

  String get iconAsset {
    return name;
  }
}

class PuzzleClue {
  final int order;
  final String text;

  PuzzleClue({required this.order, required this.text});

  factory PuzzleClue.fromJson(Map<String, dynamic> json) {
    return PuzzleClue(
      order: json['order'] as int? ?? 1,
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'order': order, 'text': text};
}

class HintLadder {
  final String gentle;
  final String guided;
  final String strong;
  final String fullSolution;

  HintLadder({
    required this.gentle,
    required this.guided,
    required this.strong,
    required this.fullSolution,
  });

  factory HintLadder.fromJson(Map<String, dynamic> json) {
    return HintLadder(
      gentle: json['gentle'] as String? ?? '',
      guided: json['guided'] as String? ?? '',
      strong: json['strong'] as String? ?? '',
      fullSolution: json['full_solution'] as String? ?? json['fullSolution'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'gentle': gentle,
    'guided': guided,
    'strong': strong,
    'full_solution': fullSolution,
  };
}

class PuzzleModel {
  final String id;
  final PuzzleCategory category;
  final String title;
  final String description;
  final PuzzleDifficulty difficulty;
  final Map<String, dynamic> puzzleData;
  final List<String> validAnswers;
  final HintLadder hintLadder;
  final String explanation;
  final int estimatedSeconds;

  PuzzleModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.puzzleData,
    required this.validAnswers,
    required this.hintLadder,
    required this.explanation,
    this.estimatedSeconds = 60,
  });

  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    final catStr = json['category'] as String? ?? 'gk';
    final category = PuzzleCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == catStr.toLowerCase(),
      orElse: () => PuzzleCategory.gk,
    );
    final diffStr = json['difficulty'] as String? ?? 'easy';
    final difficulty = PuzzleDifficulty.fromString(diffStr);

    final rawAnswers = json['valid_answers'] as List<dynamic>? ?? [];
    final validAnswers = rawAnswers.map((e) => e.toString()).toList();

    return PuzzleModel(
      id: json['id'] as String,
      category: category,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      difficulty: difficulty,
      puzzleData: json['puzzle_data'] as Map<String, dynamic>? ?? {},
      validAnswers: validAnswers,
      hintLadder: json['hint_ladder'] != null
          ? HintLadder.fromJson(json['hint_ladder'] as Map<String, dynamic>)
          : HintLadder(
              gentle: 'Consider the details carefully.',
              guided: 'Look at the relationships in the prompt.',
              strong: 'Check the primary clue.',
              fullSolution: validAnswers.isNotEmpty ? validAnswers.first : '',
            ),
      explanation: json['explanation'] as String? ?? '',
      estimatedSeconds: json['estimated_seconds'] as int? ?? 60,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category.name,
    'title': title,
    'description': description,
    'difficulty': difficulty.name,
    'puzzle_data': puzzleData,
    'valid_answers': validAnswers,
    'hint_ladder': hintLadder.toJson(),
    'explanation': explanation,
    'estimated_seconds': estimatedSeconds,
  };
}

class PuzzleSession {
  final String puzzleId;
  final PuzzleCategory category;
  final PuzzleDifficulty difficulty;
  final DateTime startTime;
  int hintsUsed;
  int moves;
  int mistakes;
  bool isAutoSolved;
  bool isCompleted;
  int earnedXP;
  Duration? duration;

  PuzzleSession({
    required this.puzzleId,
    required this.category,
    required this.difficulty,
    DateTime? startTime,
    this.hintsUsed = 0,
    this.moves = 0,
    this.mistakes = 0,
    this.isAutoSolved = false,
    this.isCompleted = false,
    this.earnedXP = 0,
    this.duration,
  }) : startTime = startTime ?? DateTime.now();

  int calculateXP() {
    if (isAutoSolved) return (difficulty.baseXP * 0.2).round();
    
    int xp = difficulty.baseXP;
    // Penalty for hints: 15% per hint up to 45%
    double hintMultiplier = 1.0 - (hintsUsed * 0.15).clamp(0.0, 0.45);
    // Penalty for mistakes: 5% per mistake up to 25%
    double mistakeMultiplier = 1.0 - (mistakes * 0.05).clamp(0.0, 0.25);
    
    xp = (xp * hintMultiplier * mistakeMultiplier).round();
    return xp < 5 ? 5 : xp;
  }
}
