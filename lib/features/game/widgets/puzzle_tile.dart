// lib/features/game/widgets/puzzle_tile.dart
import 'package:flutter/material.dart';

class PuzzleTile extends StatelessWidget {
  final Color color;
  final int index;
  final Function(int fromIndex, int toIndex) onSwap;

  const PuzzleTile({
    super.key,
    required this.color,
    required this.index,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        onSwap(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        bool uzerineGelindi = candidateData.isNotEmpty;

        return Draggable<int>(
          data: index,
          feedback: _buildKutuGorseli(isDragging: true), // Sürüklerken görünen
          childWhenDragging: Container(
            // Arkada kalan boşluk
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: _buildKutuGorseli(isHovered: uzerineGelindi), // Normal hali
        );
      },
    );
  }

  Widget _buildKutuGorseli({bool isDragging = false, bool isHovered = false}) {
    return Container(
      width: isDragging ? 60 : null, // Sürüklerken biraz büyük görünsün
      height: isDragging ? 60 : null,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          isDragging ? 30 : 4,
        ), // Sürüklerken yuvarlak
        boxShadow: isDragging
            ? [const BoxShadow(blurRadius: 10, color: Colors.black45)]
            : null,
        border: isHovered
            ? Border.all(
                color: Colors.white,
                width: 3,
              ) // Üzerine gelince parlasın
            : null,
      ),
    );
  }
}
