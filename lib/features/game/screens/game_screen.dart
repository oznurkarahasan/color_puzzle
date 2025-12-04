import 'package:flutter/material.dart';
import 'package:color_puzzle/core/utils/color_generator.dart';
import 'package:color_puzzle/features/game/widgets/puzzle_tile.dart';
import 'package:color_puzzle/core/managers/level_manager.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  final int initialLevel; // YENİ: Hangi level oynanacak?

  // Varsayılan olarak 1. level (Test için)
  const GameScreen({super.key, this.initialLevel = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int currentLevel; // 'late' kullandık çünkü initState'de atanacak
  int satirSayisi = 1;
  int sutunSayisi = 5;
  int ipucuHakki = 2;

  List<Color> hedefListe = [];
  List<Color> oyuncuListesi = [];
  Set<int> kilitliIndexler = {};

  Timer? _timer;
  Duration _gecenSure = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel(); // Sayfadan çıkınca sayacı öldür
    super.dispose();
  }

  // Sayacı Başlat/Sıfırla
  void _startTimer() {
    _timer?.cancel(); // 1. Önce varsa eski sayacı durdur (Çakışma olmasın)

    // 2. Süreyi SIFIRLA
    setState(() {
      _gecenSure = Duration.zero;
    });

    // 3. Yeni sayacı başlat
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // Ekran hala açıksa güncelle (Hata almamak için güvenlik)
        setState(() {
          _gecenSure = _gecenSure + const Duration(seconds: 1);
        });
      }
    });
  }

  // Sayacı Durdur
  void _stopTimer() {
    _timer?.cancel();
  }

  // Süreyi "02:14" formatına çeviren yardımcı fonksiyon
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();
    currentLevel = widget.initialLevel; // Gelen parametreyi al
    _leveliBaslat();
    _startTimer();
  }

  void _leveliBaslat() {
    ipucuHakki = 2;

    // LEVEL ZORLUK MANTIĞI
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

    _startTimer();

    setState(() {});
  }

  void _showWinBottomSheet() {
    _stopTimer(); // Oyunu kazandığı an süreyi durdur

    showModalBottomSheet(
      context: context,
      isDismissible: false, // Boşluğa basınca kapanmasın
      enableDrag: false, // Aşağı kaydırarak kapatılamasın
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 320, // Panelin yüksekliği
          decoration: BoxDecoration(
            color: Colors.grey[900], // Koyu zemin
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(color: Colors.white10, width: 1), // İnce çerçeve
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. TAMAMLANDI İKONU
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green,
                child: Icon(Icons.check_rounded, color: Colors.white, size: 40),
              ),

              // 2. MESAJLAR
              const Text(
                "Bölüm Tamamlandı!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 3. SÜRE GÖSTERGESİ
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Süre: ${_formatDuration(_gecenSure)}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 4. BUTONLAR (YAN YANA)
              Row(
                children: [
                  // MENÜ BUTONU
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Paneli kapat
                        Navigator.pop(context); // Haritaya dön
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Menü",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // DEVAM ET BUTONU
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Paneli kapat
                        setState(() {
                          currentLevel++;
                        });
                        _leveliBaslat(); // Yeni leveli (ve sayacı) başlat
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Devam Et",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ... (Buradaki _kilitliTaslariBelirle, _sadeceOrtalariKaristir, _ipucuKullan kodları AYNI kalacak) ...
  // KOD TEKRARI OLMASIN DİYE KISALTTIM, ESKİ KODLARINI KORU.

  // SADECE BUNU GÜNCELLEMELİSİN:
  void _kilitliTaslariBelirle() {
    kilitliIndexler.clear();
    // Level 1 mantığı veya 4 köşe mantığı aynen devam
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
    // (Eski kodunun aynısı kalsın)
    List<Color> hareketliRenkler = [];
    for (int i = 0; i < kaynak.length; i++) {
      if (!kilitliIndexler.contains(i)) hareketliRenkler.add(kaynak[i]);
    }
    hareketliRenkler.shuffle();
    List<Color> sonuc = [];
    int sayac = 0;
    for (int i = 0; i < kaynak.length; i++) {
      if (kilitliIndexler.contains(i)) {
        sonuc.add(kaynak[i]);
      } else {
        sonuc.add(hareketliRenkler[sayac++]);
      }
    }
    return sonuc;
  }

  void _ipucuKullan() {
    // (Eski kodunun aynısı kalsın)
    if (ipucuHakki <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Hakkın bitti!")));
      return;
    }
    // ... İpucu mantığı aynen devam ...
    // Sadece en sonda _kazanmaKontrolu() çağırmayı unutma.

    // HIZLI GEÇİŞ İÇİN İPUCU KODUNU TEKRAR YAZMIYORUM,
    // ÖNCEKİ CEVAPTAN KOPYALADIĞIN İPUCU MANTIĞINI BURAYA KOYABİLİRSİN.
    // AMA KISACA ŞU ŞEKİLDE OLMALI:
    int? hataliIndex;
    for (int i = 0; i < hedefListe.length; i++) {
      if (hedefListe[i].toARGB32() != oyuncuListesi[i].toARGB32() &&
          !kilitliIndexler.contains(i)) {
        hataliIndex = i;
        break;
      }
    }
    if (hataliIndex != null) {
      Color dogru = hedefListe[hataliIndex];
      int? yeri;
      for (int k = 0; k < oyuncuListesi.length; k++) {
        if (oyuncuListesi[k].toARGB32() == dogru.toARGB32()) {
          yeri = k;
          break;
        }
      }
      if (yeri != null) {
        setState(() {
          oyuncuListesi[yeri!] = oyuncuListesi[hataliIndex!];
          oyuncuListesi[hataliIndex] = dogru;
          kilitliIndexler.add(hataliIndex);
          ipucuHakki--;
        });
        _kazanmaKontrolu();
      }
    }
  }

  void _renkleriDegistir(int eskiIndex, int yeniIndex) {
    // (Eski kodunun aynısı kalsın)
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

  // GÜNCELLENMESİ GEREKEN KISIM: KAZANMA KONTROLÜ
  void _kazanmaKontrolu() {
    bool kazandi = true;
    for (int i = 0; i < hedefListe.length; i++) {
      if (hedefListe[i].toARGB32() != oyuncuListesi[i].toARGB32()) {
        kazandi = false;
        break;
      }
    }

    if (kazandi) {
      LevelManager.unlockNextLevel(currentLevel);
      _stopTimer(); // Sayacı durdur

      // Hemen paneli aç
      Future.delayed(const Duration(milliseconds: 300), () {
        _showWinBottomSheet(); // <-- BURAYI DEĞİŞTİRDİK
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
        leading: IconButton(
          icon: const Icon(Icons.grid_view_rounded), // Menüye dön
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // İPUCU ALANI
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
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // YENİLEME BUTONU
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
      // --- DEĞİŞİKLİK BURADA BAŞLIYOR ---
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortala
        children: [
          // 1. PUZZLE ALANI (GRID)
          Padding(
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

          // 2. BOŞLUK
          const SizedBox(height: 30),

          // 3. CANLI SAYAÇ GÖSTERGESİ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black26, // Hafif transparan koyu zemin
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white12), // İnce çerçeve
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Sadece yazı kadar genişle
              children: [
                const Icon(Icons.timer_outlined, color: Colors.amber, size: 24),
                const SizedBox(width: 10),
                Text(
                  _formatDuration(_gecenSure), // Canlı güncellenen süre
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2, // Dijital saat gibi geniş
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ], // Rakamlar titremesin diye
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
