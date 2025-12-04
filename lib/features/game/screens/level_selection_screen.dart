import 'package:flutter/material.dart';
import 'package:color_puzzle/core/managers/level_manager.dart';
import 'package:color_puzzle/features/game/screens/game_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final int totalLevels = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("BÖLÜMLER"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          // Her satırda 5 level olsun
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: totalLevels,
          itemBuilder: (context, index) {
            int levelNumarasi = index + 1;

            // Level Durumu Kontrolü
            bool isLocked = levelNumarasi > LevelManager.maxReachedLevel;
            bool isCurrent = levelNumarasi == LevelManager.maxReachedLevel;

            return GestureDetector(
              onTap: () {
                if (isLocked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Önce önceki bölümleri bitirmelisin! 🔒"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  _startLevel(levelNumarasi);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  // Duruma göre renk değişimi
                  color: isLocked
                      ? Colors
                            .white10 // Kilitli (Soluk Gri)
                      : isCurrent
                      ? Colors
                            .amber // Mevcut Level (Turuncu/Sarı)
                      : Colors.green, // Bitmiş (Yeşil)

                  borderRadius: BorderRadius.circular(10),
                  border: isCurrent
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(Icons.lock, color: Colors.grey, size: 20)
                      : Text(
                          "$levelNumarasi",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isCurrent ? 20 : 16,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _startLevel(int level) async {
    // Oyunu aç ve dönmesini bekle
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(initialLevel: level)),
    );

    // Oyun ekranından geri dönüldüğünde ekranı yenile (Kilitleri güncellemek için)
    setState(() {});
  }
}
