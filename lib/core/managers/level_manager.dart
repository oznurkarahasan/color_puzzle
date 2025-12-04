class LevelManager {
  // Şimdilik sadece bellekte tutuyoruz. İleride kalıcı depolama eklenebilir.
  static int maxReachedLevel = 1; // Oyuncu en son kaça kadar geldi?

  static void unlockNextLevel(int currentLevel) {
    if (currentLevel >= maxReachedLevel) {
      maxReachedLevel = currentLevel + 1;
    }
  }
}
