import 'package:flutter/material.dart';
import 'package:color_puzzle/features/game/screens/level_selection_screen.dart';
import 'package:color_puzzle/core/managers/audio_manager.dart';
import 'package:confetti/confetti.dart'; // Konfeti paketi
import 'dart:math'; // EKSİK OLAN BUYDU (cos ve sin için şart)

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _buttonController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _confettiController.play();
    });

    AudioManager().initMusic();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _buttonController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- KATMAN 1: ARKA PLAN ---
          AnimatedBuilder(
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
              );
            },
          ),

          // --- KATMAN 2: KONFETİ YAĞMURU ---
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              createParticlePath: drawStar, // Artık hata vermeyecek
              emissionFrequency: 0.05,
              numberOfParticles: 10,
              gravity: 0.2,
            ),
          ),

          // --- KATMAN 3: İÇERİK ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // EFEKTLİ LOGO
                // EFEKTLİ LOGO (JÖLE GİBİ SALLANAN VERSİYON)
                // EFEKTLİ LOGO (ABARTILI KOMİK VERSİYON)
                AnimatedBuilder(
                  animation: _buttonController,
                  builder: (context, child) {
                    // 1. SALLANMA MATEMATİĞİ (Daha Hızlı ve Daha Geniş)
                    // 4 * pi ile daha hızlı sallanır. 0.25 ile daha geniş bir açı yapar.
                    double wobble =
                        sin(_buttonController.value * 4 * pi) * 0.25;

                    // 2. BÜYÜME MATEMATİĞİ (Daha Büyük)
                    // Sallanırken %30 oranında büyüyüp küçülsün
                    double scale = 1.0 + (_buttonController.value * 0.30);

                    // Gölge daha da parlak olsun
                    double glow = _buttonController.value * 30;

                    return Transform.rotate(
                      angle: wobble, // Sağa sola çılgınca yatır
                      child: Transform.scale(
                        scale: scale, // Kocaman yap
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha: 0.5 + (_buttonController.value * 0.4),
                                ), // Daha opak gölge
                                blurRadius: 30 + glow,
                                spreadRadius: 10 + (glow / 2),
                              ),
                            ],
                          ),
                          // Resim klibi (Resmi yuvarlak kesmek için)
                          child: ClipOval(
                            child: Image.asset(
                              'assets/splash.jpg',
                              width:
                                  140, // Başlangıç boyutunu da biraz büyüttüm (120 -> 140)
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // BAŞLIK
                const Text(
                  "CO-MON",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        blurRadius: 20,
                        color: Colors.black45,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // START BUTONU
                AnimatedBuilder(
                  animation: _buttonController,
                  builder: (context, child) {
                    double scale = 1.0 + (_buttonController.value * 0.05);
                    double glow = _buttonController.value * 10;

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(
                                alpha: 0.3 + (_buttonController.value * 0.3),
                              ),
                              blurRadius: 10 + glow,
                              spreadRadius: 1 + (glow / 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LevelSelectionScreen(),
                                ),
                              );
                            }
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
                            elevation: 0,
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

          // --- KATMAN 4: SES İKONU ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    AudioManager().isMusicOn
                        ? Icons.volume_up
                        : Icons.volume_off,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      AudioManager().toggleMusic();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Yıldız çizme fonksiyonu (dart:math sayesinde çalışır)
  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }
}
