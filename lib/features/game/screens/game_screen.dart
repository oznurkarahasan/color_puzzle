import 'package:flutter/material.dart';
import 'package:color_puzzle/core/utils/color_generator.dart';
import 'package:color_puzzle/features/game/widgets/puzzle_tile.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final int satirSayisi = 4;
  List<Color> hedefListe = [];
  List<Color> oyuncuListesi = [];

  @override
  void initState() {
    super.initState();
    _oyunuBaslat();
  }

  void _oyunuBaslat() {
    hedefListe = ColorGenerator.generateGrid(
      size: satirSayisi,
      tl: Colors.red,
      tr: Colors.yellow,
      bl: Colors.blue,
      br: Colors.green,
    );
    oyuncuListesi = List.of(hedefListe)..shuffle();
    setState(() {});
  }

  void _renkleriDegistir(int eskiIndex, int yeniIndex) {
    setState(() {
      final temp = oyuncuListesi[eskiIndex];
      oyuncuListesi[eskiIndex] = oyuncuListesi[yeniIndex];
      oyuncuListesi[yeniIndex] = temp;
    });
    _kazanmaKontrolu();
  }

  void _kazanmaKontrolu() {
    bool kazandi = true;
    for (int i = 0; i < hedefListe.length; i++) {
      if (hedefListe[i].value != oyuncuListesi[i].value) {
        kazandi = false;
        break;
      }
    }
    if (kazandi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉 Bölüm Tamamlandı!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Renk Puzzle"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _oyunuBaslat),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: satirSayisi,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: oyuncuListesi.length,
              itemBuilder: (context, index) {
                return PuzzleTile(
                  color: oyuncuListesi[index],
                  index: index,
                  onSwap: _renkleriDegistir,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
