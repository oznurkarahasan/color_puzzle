import 'package:flutter/material.dart';
import 'package:color_puzzle/features/game/screens/game_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController; // Arka plan renk döngüsü için
  late AnimationController _buttonController; // Butonun nefes alma efekti için

  @override
  void initState() {
    super.initState();

    // 1. ARKA PLAN ANİMASYONU (Yavaşça döner)
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // 2. BUTON ANİMASYONU (Hızlıca nefes alır verir)
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // 0.8 saniyede bir
    )..repeat(reverse: true); // Büyü -> Küçül -> Büyü...
  }

  @override
  void dispose() {
    _bgController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HSLColor.fromAHSL(
                    1.0,
                    _bgController.value * 360,
                    0.8,
                    0.5,
                  ).toColor(),
                  HSLColor.fromAHSL(
                    1.0,
                    (_bgController.value * 360 + 60) % 360,
                    0.8,
                    0.5,
                  ).toColor(),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // BAŞLIK
                  const Text(
                    "COLOR PUZZLE",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.black38,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  // EFEKTLİ START BUTONU
                  AnimatedBuilder(
                    animation: _buttonController,
                    builder: (context, child) {
                      // Animasyon değeri 0.0 ile 1.0 arasında gidip gelir
                      // Scale: 1.0 (Normal) ile 1.05 (%5 Büyük) arasında değişsin
                      double scale = 1.0 + (_buttonController.value * 0.05);

                      // Gölge: Büyüdükçe parlasın
                      double glow = _buttonController.value * 10;

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              // Arkadaki Parlayan Işık (Glow)
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha: 0.3 + (_buttonController.value * 0.3),
                                ),
                                blurRadius:
                                    10 +
                                    glow, // Parlaklık yarıçapı artıp azalır
                                spreadRadius: 1 + (glow / 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 20,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation:
                                  0, // Kendi gölgesini kapattık, biz özel gölge yaptık
                            ),
                            child: const Text("START"),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
