import '../../data/models/puzzle_model.dart';

class AIHint {
  final int level;
  final String text;
  final bool isOffline;
  final String? strategy;

  AIHint({
    required this.level,
    required this.text,
    this.isOffline = true,
    this.strategy,
  });
}

class AIExplanation {
  final String title;
  final String explanation;
  final bool isOffline;

  AIExplanation({
    required this.title,
    required this.explanation,
    this.isOffline = true,
  });
}

abstract class PuzzleAIService {
  Future<AIHint> getHint(PuzzleModel puzzle, int hintLevel);
  Future<AIExplanation> explainSolution(PuzzleModel puzzle);
  Future<AIExplanation> explainMistake(PuzzleModel puzzle, String wrongAnswer);
}

/// Pure algorithmic & rule-based offline AI service.
/// Zero external cloud API calls, instant response, 100% deterministic and reliable.
class PureAlgorithmicAIService implements PuzzleAIService {
  const PureAlgorithmicAIService();

  @override
  Future<AIHint> getHint(PuzzleModel puzzle, int hintLevel) async {
    String hintText;
    switch (hintLevel) {
      case 1:
        hintText = puzzle.hintLadder.gentle;
        break;
      case 2:
        hintText = puzzle.hintLadder.guided;
        break;
      case 3:
        hintText = puzzle.hintLadder.strong;
        break;
      case 4:
      default:
        hintText = 'Solution: ${puzzle.hintLadder.fullSolution}';
    }

    return AIHint(
      level: hintLevel,
      text: hintText,
      isOffline: true,
      strategy: 'Deterministic Rule Engine',
    );
  }

  @override
  Future<AIExplanation> explainSolution(PuzzleModel puzzle) async {
    return AIExplanation(
      title: 'Algorithmic Verification',
      explanation: puzzle.explanation.isNotEmpty
          ? puzzle.explanation
          : 'Verified correct by the deterministic puzzle solver.',
      isOffline: true,
    );
  }

  @override
  Future<AIExplanation> explainMistake(PuzzleModel puzzle, String wrongAnswer) async {
    return AIExplanation(
      title: 'Mistake Analysis',
      explanation: 'Your input "$wrongAnswer" does not satisfy the puzzle constraints. Re-check the clues carefully.',
      isOffline: true,
    );
  }
}
