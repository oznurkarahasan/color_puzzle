import 'package:flutter/material.dart';

class ColorGenerator {
  /// Verilen 4 köşe rengine göre grid boyutu kadar ara renk üretir.
  static List<Color> generateGrid({
    required int size,
    required Color tl, // Top-Left (Sol Üst)
    required Color tr, // Top-Right (Sağ Üst)
    required Color bl, // Bottom-Left (Sol Alt)
    required Color br, // Bottom-Right (Sağ Alt)
  }) {
    List<Color> result = [];

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        double xRatio = size > 1 ? x / (size - 1) : 0;
        double yRatio = size > 1 ? y / (size - 1) : 0;

        // Üst ve Alt satır interpolasyonu
        Color topColor = Color.lerp(tl, tr, xRatio)!;
        Color bottomColor = Color.lerp(bl, br, xRatio)!;

        // Dikey interpolasyon
        Color finalColor = Color.lerp(topColor, bottomColor, yRatio)!;

        result.add(finalColor);
      }
    }
    return result;
  }
}
