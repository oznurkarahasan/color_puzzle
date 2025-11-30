import 'package:flutter/material.dart';
import 'dart:math';

class ColorGenerator {
  // Artık size yerine rows ve cols alıyoruz
  static List<Color> generateLevelColors({
    required int rows,
    required int cols,
  }) {
    final Random random = Random();

    // Rastgele Ana Renk
    double baseHue = random.nextDouble() * 360;

    // Köşeleri HSL ile üret (Daha canlı renkler için parametreleri güncelledim)
    Color tl = HSLColor.fromAHSL(1.0, baseHue, 0.5, 0.9).toColor(); // Çok Açık
    Color tr = HSLColor.fromAHSL(1.0, baseHue, 0.8, 0.8).toColor(); // Açık
    Color bl = HSLColor.fromAHSL(1.0, baseHue, 0.5, 0.3).toColor(); // Koyu
    Color br = HSLColor.fromAHSL(1.0, baseHue, 1.0, 0.1).toColor(); // Çok Koyu

    List<Color> result = [];

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        // MATEMATİKSEL KORUMA:
        // Eğer tek satırsa (rows=1), bölen 0 olur ve hata verir.
        // Bunu engellemek için kontrol ekledik (? : yapısı).
        double xRatio = cols > 1 ? x / (cols - 1) : 0;
        double yRatio = rows > 1 ? y / (rows - 1) : 0;

        Color topColor = Color.lerp(tl, tr, xRatio)!;
        Color bottomColor = Color.lerp(bl, br, xRatio)!;

        // Eğer tek satırsa sadece üst rengi (topColor) kullan, karıştırma.
        Color finalColor = rows > 1
            ? Color.lerp(topColor, bottomColor, yRatio)!
            : topColor;

        result.add(finalColor);
      }
    }
    return result;
  }
}
