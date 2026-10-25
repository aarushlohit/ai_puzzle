import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PhotoJigsawWidget extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final String answerName;
  final String gentleHint;
  final String guidedHint;
  final String strongHint;
  final int gridSize; // 3 for 3x3 (9 pieces)
  final VoidCallback onSolved;
  final bool isAutoSolveRequested;

  const PhotoJigsawWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.answerName,
    required this.gentleHint,
    required this.guidedHint,
    required this.strongHint,
    this.gridSize = 3,
    required this.onSolved,
    this.isAutoSolveRequested = false,
  });

  @override
  State<PhotoJigsawWidget> createState() => PhotoJigsawWidgetState();
}

class PhotoJigsawWidgetState extends State<PhotoJigsawWidget> {
  late List<int> _currentTiles; // Current tile order (indices 0..8)
  int? _selectedTileIndex;
  int _moves = 0;
  bool _isAutoSolving = false;
  String? _stepNotification;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _resetPuzzle();
  }

  @override
  void didUpdateWidget(PhotoJigsawWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAutoSolveRequested && !oldWidget.isAutoSolveRequested && !_isAutoSolving && !_isCompleted) {
      triggerAutoSolve();
    }
  }

  void _resetPuzzle() {
    final total = widget.gridSize * widget.gridSize;
    // Create a deterministic scrambled order
    final scrambled = List.generate(total, (i) => i);
    // Swap pairs so it is scrambled but guaranteed solvable
    for (int i = 0; i < total - 1; i += 2) {
      final tmp = scrambled[i];
      scrambled[i] = scrambled[i + 1];
      scrambled[i + 1] = tmp;
    }

    setState(() {
      _currentTiles = scrambled;
      _selectedTileIndex = null;
      _moves = 0;
      _isAutoSolving = false;
      _stepNotification = null;
      _isCompleted = false;
    });
  }

  void _onTileTap(int tappedPosition) {
    if (_isAutoSolving || _isCompleted) return;

    if (_selectedTileIndex == null) {
      setState(() {
        _selectedTileIndex = tappedPosition;
      });
    } else {
      if (_selectedTileIndex != tappedPosition) {
        // Swap pieces
        setState(() {
          final temp = _currentTiles[_selectedTileIndex!];
          _currentTiles[_selectedTileIndex!] = _currentTiles[tappedPosition];
          _currentTiles[tappedPosition] = temp;
          _selectedTileIndex = null;
          _moves++;
        });

        _checkWin();
      } else {
        // Deselect
        setState(() {
          _selectedTileIndex = null;
        });
      }
    }
  }

  void _checkWin() {
    for (int i = 0; i < _currentTiles.length; i++) {
      if (_currentTiles[i] != i) return;
    }
    setState(() {
      _isCompleted = true;
    });
    widget.onSolved();
  }

  /// Deliberate step-by-step Auto-Solve with visual hints and paced tile swaps
  Future<void> triggerAutoSolve() async {
    if (_isAutoSolving || _isCompleted) return;

    setState(() {
      _isAutoSolving = true;
      _stepNotification = 'Step 1/4 (Gentle Clue): ${widget.gentleHint}';
    });
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() {
      _stepNotification = 'Step 2/4 (Strategy): ${widget.guidedHint}';
    });
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() {
      _stepNotification = 'Step 3/4 (Strong Deduction): ${widget.strongHint}';
    });
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() {
      _stepNotification = 'Step 4/4: Reassembling photo jigsaw step by step...';
    });

    final total = widget.gridSize * widget.gridSize;

    // Bring each piece to its correct slot one-by-one with clear visual pacing
    for (int targetSlot = 0; targetSlot < total; targetSlot++) {
      if (!mounted) return;
      if (_currentTiles[targetSlot] == targetSlot) continue;

      // Find where piece targetSlot is located currently
      final currentPos = _currentTiles.indexOf(targetSlot);

      // Highlight the pieces being swapped
      setState(() {
        _selectedTileIndex = currentPos;
      });
      await Future.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;

      setState(() {
        final temp = _currentTiles[targetSlot];
        _currentTiles[targetSlot] = _currentTiles[currentPos];
        _currentTiles[currentPos] = temp;
        _selectedTileIndex = null;
        _moves++;
      });

      await Future.delayed(const Duration(milliseconds: 550));
    }

    setState(() {
      _isCompleted = true;
      _isAutoSolving = false;
      _stepNotification = 'Photo Jigsaw Assembled: ${widget.answerName}!';
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      widget.onSolved();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = widget.gridSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Header info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Swaps: $_moves',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentLavender.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _isCompleted ? 'Solved!' : 'Tap 2 tiles to swap',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: AppColors.accentPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Clue step notification
          if (_stepNotification != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentLavender.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.4)),
              ),
              child: Text(
                _stepNotification!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.accentPurple,
                ),
              ),
            ),

          // Interactive 3x3 Photo Jigsaw Grid
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalTilesCount(size),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  itemBuilder: (context, slotIndex) {
                    final originalPieceIndex = _currentTiles[slotIndex];
                    final isSelected = _selectedTileIndex == slotIndex;

                    // Calculate original row and col of this piece in the source photo
                    final origRow = originalPieceIndex ~/ size;
                    final origCol = originalPieceIndex % size;

                    // Compute alignment offset for fractional cropping:
                    // Alignment ranges from -1.0 (left/top) to +1.0 (right/bottom)
                    final alignX = size > 1 ? -1.0 + (origCol * 2.0 / (size - 1)) : 0.0;
                    final alignY = size > 1 ? -1.0 + (origRow * 2.0 / (size - 1)) : 0.0;

                    return GestureDetector(
                      onTap: () => _onTileTap(slotIndex),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.amber
                                : (originalPieceIndex == slotIndex ? AppColors.success.withValues(alpha: 0.6) : Colors.black12),
                            width: isSelected ? 3 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              FittedBox(
                                fit: BoxFit.none,
                                alignment: Alignment(alignX, alignY),
                                child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: Image.asset(
                                    widget.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Subtle piece number badge in corner
                              Positioned(
                                top: 2,
                                left: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${originalPieceIndex + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Controls with responsive Expanded layout
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isAutoSolving ? null : _resetPuzzle,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Scramble', maxLines: 1, overflow: TextOverflow.ellipsis),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAutoSolving || _isCompleted ? null : triggerAutoSolve,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Auto-Solve', maxLines: 1, overflow: TextOverflow.ellipsis),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  int totalTilesCount(int size) => size * size;
}
