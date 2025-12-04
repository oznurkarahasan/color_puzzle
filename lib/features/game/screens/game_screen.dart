import 'package:flutter/material.dart';
import 'package:color_puzzle/core/utils/color_generator.dart';
import 'package:color_puzzle/features/game/widgets/puzzle_tile.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentLevel = 1;
  int satirSayisi = 1;
  int sutunSayisi = 5;
  int ipucuHakki = 2;

  List<Color> hedefListe = [];
  List<Color> oyuncuListesi = [];
  Set<int> kilitliIndexler = {};

  @override
  void initState() {
    super.initState();
    _leveliBaslat();
  }

  void _leveliBaslat() {
    ipucuHakki = 2;

    if (currentLevel == 1) {
      satirSayisi = 1;
      sutunSayisi = 5;
    } else if (currentLevel == 2) {
      satirSayisi = 3;
      sutunSayisi = 3;
    } else {
      int baseSize = 4 + ((currentLevel - 3) ~/ 2);
      satirSayisi = baseSize;
      sutunSayisi = baseSize;
    }

    hedefListe = ColorGenerator.generateLevelColors(
      rows: satirSayisi,
      cols: sutunSayisi,
    );
    _kilitliTaslariBelirle();
    oyuncuListesi = _sadeceOrtalariKaristir(hedefListe);

    setState(() {});
  }

  void _kilitliTaslariBelirle() {
    kilitliIndexler.clear();
    if (currentLevel == 1) {
      kilitliIndexler.add(0);
      kilitliIndexler.add(sutunSayisi - 1);
    } else {
      kilitliIndexler.add(0);
      kilitliIndexler.add(sutunSayisi - 1);
      kilitliIndexler.add((satirSayisi - 1) * sutunSayisi);
      kilitliIndexler.add((satirSayisi * sutunSayisi) - 1);
    }
  }

  List<Color> _sadeceOrtalariKaristir(List<Color> kaynak) {
    List<Color> hareketliRenkler = [];
    for (int i = 0; i < kaynak.length; i++) {
      if (!kilitliIndexler.contains(i)) {
        hareketliRenkler.add(kaynak[i]);
      }
    }
    hareketliRenkler.shuffle();

    List<Color> sonuc = [];
    int hareketliSayac = 0;
    for (int i = 0; i < kaynak.length; i++) {
      if (kilitliIndexler.contains(i)) {
        sonuc.add(kaynak[i]);
      } else {
        sonuc.add(hareketliRenkler[hareketliSayac]);
        hareketliSayac++;
      }
    }
    return sonuc;
  }

  void _ipucuKullan() {
    if (ipucuHakki <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bu bölüm için ipucu bitti!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    int? hataliIndex;
    for (int i = 0; i < hedefListe.length; i++) {
      if (hedefListe[i].toARGB32() != oyuncuListesi[i].toARGB32() &&
          !kilitliIndexler.contains(i)) {
        hataliIndex = i;
        break;
      }
    }

    if (hataliIndex == null) return;

    Color dogruRenk = hedefListe[hataliIndex];
    int? suAnkiYeri;
    for (int k = 0; k < oyuncuListesi.length; k++) {
      if (oyuncuListesi[k].toARGB32() == dogruRenk.toARGB32()) {
        suAnkiYeri = k;
        break;
      }
    }

    if (suAnkiYeri != null) {
      setState(() {
        oyuncuListesi[suAnkiYeri!] = oyuncuListesi[hataliIndex!];
        oyuncuListesi[hataliIndex] = dogruRenk;

        kilitliIndexler.add(hataliIndex);
        ipucuHakki--;
        // Efekt tetikleme kodları kaldırıldı
      });

      _kazanmaKontrolu();
    }
  }

  void _renkleriDegistir(int eskiIndex, int yeniIndex) {
    if (kilitliIndexler.contains(yeniIndex) ||
        kilitliIndexler.contains(eskiIndex)) {
      return;
    }

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
      if (hedefListe[i].toARGB32() != oyuncuListesi[i].toARGB32()) {
        kazandi = false;
        break;
      }
    }

    if (kazandi) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Level $currentLevel Tamamlandı! 🎉"),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          currentLevel++;
        });
        _leveliBaslat();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Level $currentLevel"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.lightbulb,
                    color: ipucuHakki > 0 ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: _ipucuKullan,
                ),
                if (ipucuHakki > 0)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "$ipucuHakki",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                oyuncuListesi = _sadeceOrtalariKaristir(hedefListe);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AspectRatio(
            aspectRatio: satirSayisi == 1 ? 5 / 1 : 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: sutunSayisi,
                childAspectRatio: 1,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: oyuncuListesi.length,
              itemBuilder: (context, index) {
                bool isLocked = kilitliIndexler.contains(index);

                return PuzzleTile(
                  color: oyuncuListesi[index],
                  index: index,
                  isLocked: isLocked,
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
