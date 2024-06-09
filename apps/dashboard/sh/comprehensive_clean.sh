rm -rf ios/Pods
rm -rf ios/.symlinks
rm ios/Podfile.lock
flutter clean
flutter pub get
cd ios
pod repo update
pod install
