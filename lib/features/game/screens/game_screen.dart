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

  List<Color> hedefListe = [];
  List<Color> oyuncuListesi = [];

  // YENİ: Kilitli olan indexleri tutan liste
  Set<int> kilitliIndexler = {};

  @override
  void initState() {
    super.initState();
    _leveliBaslat();
  }

  void _leveliBaslat() {
    // --- LEVEL AYARLARI ---
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

    // 1. Hedef renkleri oluştur (Bu bizim cevap anahtarımız)
    hedefListe = ColorGenerator.generateLevelColors(
      rows: satirSayisi,
      cols: sutunSayisi,
    );

    // 2. Kilitli olacak taşları belirle (Köşeler)
    _kilitliTaslariBelirle();

    // 3. AKILLI KARIŞTIRMA (Sadece ortadakileri karıştır)
    oyuncuListesi = _sadeceOrtalariKaristir(hedefListe);

    setState(() {});
  }

  void _kilitliTaslariBelirle() {
    kilitliIndexler.clear();

    if (currentLevel == 1) {
      // Level 1 için sadece en başı ve en sonu kilitleyelim (Kolaylık olsun)
      kilitliIndexler.add(0); // İlk kutu
      kilitliIndexler.add(sutunSayisi - 1); // Son kutu
    } else {
      // Diğer levellerde 4 köşeyi kilitle
      kilitliIndexler.add(0); // Sol Üst
      kilitliIndexler.add(sutunSayisi - 1); // Sağ Üst
      kilitliIndexler.add((satirSayisi - 1) * sutunSayisi); // Sol Alt
      kilitliIndexler.add((satirSayisi * sutunSayisi) - 1); // Sağ Alt
    }
  }

  List<Color> _sadeceOrtalariKaristir(List<Color> kaynak) {
    // Hareket edebilir (kilitli olmayan) renkleri ayıkla
    List<Color> hareketliRenkler = [];
    for (int i = 0; i < kaynak.length; i++) {
      if (!kilitliIndexler.contains(i)) {
        hareketliRenkler.add(kaynak[i]);
      }
    }

    // Bunları karıştır
    hareketliRenkler.shuffle();

    // Şimdi yeni listeyi inşa et
    List<Color> sonuc = [];
    int hareketliSayac = 0;

    for (int i = 0; i < kaynak.length; i++) {
      if (kilitliIndexler.contains(i)) {
        // Eğer kilitli bir yerse, orijinal (doğru) rengi koy
        sonuc.add(kaynak[i]);
      } else {
        // Değilse, karıştırdığımız havuzdan sıradakini koy
        sonuc.add(hareketliRenkler[hareketliSayac]);
        hareketliSayac++;
      }
    }
    return sonuc;
  }

  void _renkleriDegistir(int eskiIndex, int yeniIndex) {
    // Eğer hedef yer kilitliyse değişime izin verme (Ekstra güvenlik)
    if (kilitliIndexler.contains(yeniIndex) ||
        kilitliIndexler.contains(eskiIndex))
      return;

    setState(() {
      final temp = oyuncuListesi[eskiIndex];
      oyuncuListesi[eskiIndex] = oyuncuListesi[yeniIndex];
      oyuncuListesi[yeniIndex] = temp;
    });
    _kazanmaKontrolu();
  }

  // _kazanmaKontrolu, _levelAtla ve build metodunun geri kalanı aynı...
  // Sadece PuzzleTile çağırırken parametreyi ekle:

  // ... build metodunun içinde GridView.builder kısmında:
  /*
  itemBuilder: (context, index) {
      bool isLocked = kilitliIndexler.contains(index); // Burayı hesapla
      
      return PuzzleTile(
        color: oyuncuListesi[index],
        index: index,
        isLocked: isLocked, // YENİ PARAMETREYİ GEÇ
        onSwap: _renkleriDegistir,
      );
  },
  */

  // Kodun tamamını bozmamak için build metodunu buraya tekrar ekliyorum:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Level $currentLevel"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Yenilerken de sadece ortaları karıştır
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
                // Kilit kontrolü
                bool isLocked = kilitliIndexler.contains(index);

                return PuzzleTile(
                  color: oyuncuListesi[index],
                  index: index,
                  isLocked: isLocked, // Widget'a bildiriyoruz
                  onSwap: _renkleriDegistir,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // _kazanmaKontrolu ve _levelAtla fonksiyonlarını önceki kodundan aynen kullanabilirsin.
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
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          currentLevel++;
        });
        _leveliBaslat();
      });
    }
  }
}
