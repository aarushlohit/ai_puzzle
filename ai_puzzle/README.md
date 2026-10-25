# PUZZLEVERSE AI — Think. Solve. Discover.
### AI-Powered Interactive Puzzle Solver Using Intelligent Agents, Search Algorithms, and Generative AI

[![Flutter](https://img.shields.io/badge/Flutter-3.47.1-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.1-blue.svg)](https://dart.dev)
[![FastAPI](https://img.shields.io/badge/Backend-FastAPI-green.svg)](https://fastapi.tiangolo.com)
[![Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)]()

---

## 1. Project Overview

**PUZZLEVERSE AI** is an academic Artificial Intelligence capstone project engineered as a consumer-grade mobile puzzle platform. It provides genuine algorithmic puzzle-solving mechanics across **15 distinct categories**, with classical search algorithms, constraint satisfaction, probabilistic inference, adaptive heuristic difficulty, and a hybrid AI hint ladder backed by Google Gemini and an offline deterministic fallback.

---

## 2. Key Features

- **15 Playable Puzzle Categories**:
  1. *Sliding Number Puzzle*: Solved via **A\*** (Manhattan distance heuristic) and **IDA\***.
  2. *Sudoku Masters*: 9×9 constraint grids solved with **Recursive Backtracking** and live trace recording.
  3. *Maze Solver*: Dynamic randomized DFS generation with **BFS** (optimal shortest path) & **A\*** heuristic pathfinding.
  4. *Mathematical Puzzles*: Polynomial/arithmetic/geometric sequences and **Bayesian Diagnostic Reasoning** (CO4).
  5. *Animal Mysteries*: Anatomical and behavioral clue deduction.
  6. *Bird Intelligence*: Avian aerodynamics, migration patterns, and morphological adaptations.
  7. *General Knowledge*: History of science, cosmology, and computing pioneers.
  8. *Logical Reasoning*: Knights and Knaves, truth tables, and deduction chains.
  9. *Pattern Recognition*: Rotational invariance and geometric progressions.
  10. *Word Puzzles*: 1-letter delta word ladders, anagrams, and palindromes.
  11. *Cryptography Puzzles*: Caesar shifts, ROT13, Atbash, and substitution codes.
  12. *Memory Challenges*: Spatial recall and symbol pairing.
  13. *Chess Tactics*: Back-rank mates, smothered mates, and tactical motifs.
  14. *Detective Mysteries*: Forensic timeline reconstruction and alibi contradictions.
  15. *AI Mixed Challenge*: Multi-stage Turing-Archimedes hybrid enigmas.

- **4-Tier Progressive AI Hint Ladder**:
  - **Tier 1 (Gentle)**: Small clue without revealing the premise.
  - **Tier 2 (Guided)**: Strategic rule or mathematical invariant.
  - **Tier 3 (Strong)**: Concrete deduction or next best step.
  - **Tier 4 (Solution)**: Verified legal solution with algorithmic justification.

- **Academic Algorithm Visualizer**:
  - Live side-by-side comparison of **BFS**, **DFS**, and **A\*** search trees.
  - Measures execution time ($\mu\text{s}$), nodes visited, and discovered path length.

- **Offline-First Resilience**:
  - The entire application, all deterministic solvers, and hint ladders work without an internet connection.
  - The optional Gemini backend smoothly enriches explanations if available.

---

## 3. Academic Course Outcome Mapping

| Course Outcome | Academic Competency | Demonstrated In Application |
|---|---|---|
| **CO1** | *Intelligent Agents & Problem Solving* | Pure Dart state transitions, legal move validators, goal-state tests, and animated solution playback. |
| **CO2** | *Uninformed & Informed Search Techniques* | BFS (shortest path), DFS (maze traversal & search space), A\* ($f(n) = g(n) + h(n)$ with Manhattan distance), IDA\* (iterative deepening). |
| **CO4** | *Probabilistic & Rule-Based Reasoning* | Explicit Sudoku & Logic constraint satisfaction, Adaptive Heuristic Difficulty modeling, and Bayesian Inference Puzzles ($P(C\|T+)$ calculation). |

---

## 4. Android APK Deliverable

The debug APK has been compiled and is ready for installation:

📍 **APK Path:**
```
ai_puzzle/build/app/outputs/flutter-apk/app-debug.apk
```

---

## 5. Quickstart & Execution Commands

### Prerequisites
- Flutter SDK 3.47+ & Dart 3.13+
- Android SDK Platform 35
- Python 3.10+ (for optional Gemini backend)

### Running the Flutter Application
```bash
cd ai_puzzle
flutter pub get
flutter run
```

### Running Automated Test Suite
```bash
flutter test
```

### Running the Optional Backend (FastAPI + Gemini)
```bash
cd ai_puzzle/backend
pip install -r requirements.txt
# Set your Gemini API key in backend/.env:
# GEMINI_API_KEY=your_key_here
uvicorn app.main:app --reload --port 8000
```
