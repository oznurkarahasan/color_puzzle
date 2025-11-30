import 'package:flutter/material.dart';

class PuzzleTile extends StatelessWidget {
  final Color color;
  final int index;
  final bool isLocked; // YENİ: Taş kilitli mi?
  final Function(int fromIndex, int toIndex) onSwap;

  const PuzzleTile({
    super.key,
    required this.color,
    required this.index,
    required this.isLocked, // YENİ
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Eğer taş kilitliyse, sürüklenebilir olmamalı.
    // Sadece görüntüsünü döndürürüz.
    if (isLocked) {
      return _buildKutuGorseli(isLocked: true);
    }

    // 2. Kilitli değilse normal sürükle-bırak mantığı çalışır.
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
        border: isHovered ? Border.all(color: Colors.white, width: 3) : null,
      ),
      // KİLİTLİ İSE ORTASINA KÜÇÜK BİR NOKTA KOY (İPUCU)
      child: isLocked
          ? const Icon(Icons.circle, size: 8, color: Colors.black26)
          : null,
    );
  }
}
