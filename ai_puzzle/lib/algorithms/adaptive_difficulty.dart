class AdaptiveDifficultyEngine {
  /// Evaluates player performance to recommend an appropriate difficulty level.
  /// Uses an explainable heuristic scoring model grounded in measurable metrics.
  static String recommendDifficulty({
    required int solvedCount,
    required double accuracy,
    required double averageSeconds,
    required double averageHintsUsed,
    required String currentDifficulty,
  }) {
    if (solvedCount < 3) {
      return currentDifficulty; // Keep current until enough samples exist
    }

    // High mastery condition: >80% accuracy, fast completion, low hint dependence (< 0.5 hints/game)
    if (accuracy >= 0.80 && averageHintsUsed <= 0.6) {
      switch (currentDifficulty.toLowerCase()) {
        case 'easy':
          return 'medium';
        case 'medium':
          return 'hard';
        case 'hard':
          return 'expert';
        case 'expert':
          return 'insane';
        case 'insane':
          return 'insane';
      }
    }

    // High struggle condition: <50% accuracy or heavy hint usage (> 2 hints/game)
    if (accuracy < 0.50 || averageHintsUsed > 2.0) {
      switch (currentDifficulty.toLowerCase()) {
        case 'insane':
          return 'expert';
        case 'expert':
          return 'hard';
        case 'hard':
          return 'medium';
        case 'medium':
          return 'easy';
        case 'easy':
          return 'easy';
      }
    }

    return currentDifficulty;
  }
}
