import 'dart:math';

class MathGenerator {
  // Generate sequence questions like 2, 6, 12, 20, 30, ?
  static Map<String, dynamic> generateSequence(String difficulty) {
    final random = Random();
    int type = random.nextInt(4);

    switch (difficulty.toLowerCase()) {
      case 'easy':
        // Linear or simple quadratic
        if (type == 0) {
          int start = random.nextInt(10) + 1;
          int step = random.nextInt(5) + 2;
          final seq = List.generate(5, (i) => start + i * step);
          final ans = start + 5 * step;
          return {
            'question': 'Identify the next number in the sequence:\n${seq.join(', ')}, ?',
            'sequence': seq,
            'answer': '$ans',
            'explanation': 'Arithmetic progression with constant common difference of +$step.',
            'gentle': 'Observe the difference between consecutive numbers.',
            'guided': 'Each number increases by exactly $step.',
            'strong': 'Add $step to ${seq.last} to find the missing value.',
          };
        } else {
          // Double sequence: 3, 6, 12, 24, 48
          int start = random.nextInt(4) + 2;
          final seq = List.generate(5, (i) => start * pow(2, i).toInt());
          final ans = start * pow(2, 5).toInt();
          return {
            'question': 'What is the missing number in the sequence?\n${seq.join(', ')}, ?',
            'sequence': seq,
            'answer': '$ans',
            'explanation': 'Geometric sequence where each term is multiplied by 2.',
            'gentle': 'Compare how fast the numbers are growing.',
            'guided': 'Notice that each term is twice the preceding term.',
            'strong': 'Multiply the last term (${seq.last}) by 2 to get $ans.',
          };
        }

      case 'medium':
        // Quadratic: n^2 + n or triangular numbers
        if (type % 2 == 0) {
          // n*(n+1) -> 2, 6, 12, 20, 30, ? -> 42
          final seq = List.generate(5, (i) => (i + 1) * (i + 2));
          final ans = 6 * 7;
          return {
            'question': 'Determine the missing number:\n${seq.join(', ')}, ?',
            'sequence': seq,
            'answer': '$ans',
            'explanation': 'Formula is n*(n+1) where n ranges from 1 to 6. Consecutive differences are +4, +6, +8, +10, +12.',
            'gentle': 'Compute the first differences between consecutive terms.',
            'guided': 'Differences increase by 2: +4, +6, +8, +10. Next difference is +12.',
            'strong': 'Add 12 to 30 to reach $ans.',
          };
        } else {
          // Squares minus 1: 3, 8, 15, 24, 35, ? -> 48
          final seq = List.generate(5, (i) => (i + 2) * (i + 2) - 1);
          final ans = 7 * 7 - 1;
          return {
            'question': 'Complete the mathematical pattern:\n${seq.join(', ')}, ?',
            'sequence': seq,
            'answer': '$ans',
            'explanation': 'Pattern is n^2 - 1 starting from n = 2. 7^2 - 1 = 48.',
            'gentle': 'Look at numbers near perfect squares.',
            'guided': 'Each number is exactly one less than a square: 4-1, 9-1, 16-1...',
            'strong': 'Calculate 7 squared minus 1.',
          };
        }

      case 'hard':
      case 'expert':
      case 'insane':
      default:
        // Fibonacci variations or alternating operators
        // Alternating: *2, -1 -> 2, 4, 3, 6, 5, 10, ? -> 9
        final seq = [2, 4, 3, 6, 5, 10];
        final ans = 9;
        return {
          'question': 'Crack the advanced alternating sequence:\n${seq.join(', ')}, ?',
          'sequence': seq,
          'answer': '$ans',
          'explanation': 'Alternating operations: multiply by 2, then subtract 1. 10 - 1 = 9.',
          'gentle': 'The pattern switches between two different arithmetic operations.',
          'guided': 'Operation pattern is (*2), (-1), (*2), (-1), (*2), then (-1).',
          'strong': 'The last operation was *2 (5*2=10). Now apply -1.',
        };
    }
  }

  // Bayesian Probabilistic Reasoning Generator (For Academic AI CO4 Requirement)
  static Map<String, dynamic> generateBayesPuzzle() {
    return {
      'title': 'Medical Diagnostic Inference (Bayes Theorem)',
      'scenario': 'In a population, 1% of people have a rare condition (Prior P(C) = 0.01). A diagnostic AI test has 90% sensitivity (True Positive Rate P(T+|C) = 0.90) and a 9% false positive rate (P(T+|~C) = 0.09). If a randomly tested individual tests positive, what is the posterior probability that they actually have the condition? (Answer as a percentage rounded to 1 decimal place, e.g., 9.2)',
      'answer': '9.2',
      'tolerance': 0.2,
      'explanation': 'Using Bayes Rule: P(C|T+) = [P(T+|C) * P(C)] / [P(T+|C)*P(C) + P(T+|~C)*P(~C)]. Numerator: 0.90 * 0.01 = 0.009. Denominator: 0.009 + (0.09 * 0.99) = 0.009 + 0.0891 = 0.0981. Posterior = 0.009 / 0.0981 = 0.09174 (~9.2%).',
      'gentle': 'Recall Bayes Theorem: Posterior = (Likelihood * Prior) / Total Evidence.',
      'guided': 'Total probability of testing positive includes both true positives (0.90 * 0.01) and false positives (0.09 * 0.99).',
      'strong': 'Divide 0.009 by 0.0981 and multiply by 100.',
    };
  }
}
