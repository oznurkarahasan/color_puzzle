import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:color_puzzle/core/utils/color_generator.dart';

void main() {
  group('Renk Üretici Testleri', () {
    test('4x4 Grid tam olarak 16 adet renk üretmeli', () {
      // Arrange (Hazırlık)
      final colors = ColorGenerator.generateLevelColors(rows: 4, cols: 4);

      // Assert (Kontrol)
      expect(colors.length, 16);
    });

    test('1x5 Şerit (Tek satır) tam olarak 5 adet renk üretmeli', () {
      final colors = ColorGenerator.generateLevelColors(rows: 1, cols: 5);

      expect(colors.length, 5);
    });

    test('Üretilen liste geçerli Color nesneleri içermeli', () {
      final colors = ColorGenerator.generateLevelColors(rows: 2, cols: 2);

      expect(colors.isNotEmpty, true);
      expect(colors.first, isA<Color>());
    });
  });
}
