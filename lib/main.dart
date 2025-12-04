import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'features/game/screens/game_screen.dart';
import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env yükleme denemesi
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ .env dosyası başarıyla yüklendi.");
  } catch (e) {
    debugPrint("⚠️ .env dosyası bulunamadı. Varsayılan ayarlar kullanılacak.");
  }

  runApp(const RenkPuzzleApp());
}

class RenkPuzzleApp extends StatelessWidget {
  const RenkPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renk Puzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const SplashScreen(),
    );
  }
}
