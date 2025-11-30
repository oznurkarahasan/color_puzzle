# Color Gradient Puzzle

Flutter ile geliştirilen, renk tonlarını doğru sıraya dizmeye dayalı bir puzzle oyunu.

## 🚀 Başlangıç

1. Repoyu klonlayın.
2. `.env.example` dosyasını kopyalayıp `.env` yapın.
3. Bağımlılıkları yükleyin: `flutter pub get`
4. Çalıştırın: `flutter run`

## ⚙️ CI/CD

Bu proje GitHub Actions ile korunmaktadır. Her `push` işleminde:

- `flutter analyze` ile kod kalitesi kontrol edilir.
- `flutter test` ile birim testler çalıştırılır.

# Tüm bağımlılıkları requirements.txt'den yüklemek için:

pip install -r requirements.txt

# Her kurulum / güncelleme sonrası

pip freeze > requirements.txt
