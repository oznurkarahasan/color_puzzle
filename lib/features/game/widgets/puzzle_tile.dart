import 'package:flutter/material.dart';

class PuzzleTile extends StatelessWidget {
  final Color color;
  final int index;
  final bool isLocked;
  // showHintEffect parametresini kaldırdık
  final Function(int fromIndex, int toIndex) onSwap;

  const PuzzleTile({
    super.key,
    required this.color,
    required this.index,
    required this.isLocked,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    // Kilitliyse (veya İpucu ile yerine konduysa) sadece görüntüyü göster
    if (isLocked) {
      return _buildKutuGorseli(isLocked: true);
    }

    // Değilse sürükle-bırak çalışsın
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        onSwap(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        bool uzerineGelindi = candidateData.isNotEmpty;

        return Draggable<int>(
          data: index,
          feedback: _buildKutuGorseli(isDragging: true),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: _buildKutuGorseli(isHovered: uzerineGelindi),
        );
      },
    );
  }

  Widget _buildKutuGorseli({
    bool isDragging = false,
    bool isHovered = false,
    bool isLocked = false,
  }) {
    return Container(
      width: isDragging ? 60 : null,
      height: isDragging ? 60 : null,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isDragging ? 30 : 4),
        boxShadow: isDragging
            ? [const BoxShadow(blurRadius: 10, color: Colors.black45)]
            : null,
        border: isHovered
            ? Border.all(color: Colors.white, width: 3)
            : isLocked
            ? Border.all(
                color: Colors.black12,
                width: 1,
              ) // Kilitliler hafif çerçeveli
            : null,
      ),
      // Sadece nokta işareti (kilit) kaldı
      child: isLocked
          ? const Icon(Icons.circle, size: 6, color: Colors.black26)
          : null,
    );
  }
}
