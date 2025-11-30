import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:color_puzzle/core/utils/color_generator.dart';

void main() {
  group('Renk Üretici Testleri', () {
    test('6x6 Grid tam olarak 36 adet renk üretmeli', () {
      // Arrange (Hazırlık)
      final colors = ColorGenerator.generateGrid(
        size: 6,
        tl: Colors.red,
        tr: Colors.blue,
        bl: Colors.green,
        br: Colors.yellow,
      );

      // Assert (Kontrol)
      expect(colors.length, 36);
    });

    test('Sol üst köşe rengi kırmızı olmalı', () {
      final colors = ColorGenerator.generateGrid(
        size: 4,
        tl: Colors.red,
        tr: Colors.blue,
        bl: Colors.green,
        br: Colors.yellow,
      );
      expect(
        colors.first.toARGB32(),
        Colors.red.toARGB32(),
      ); // Grid'in ilk elemanı sol üst köşedir
    });
  });
}
