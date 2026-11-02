#  To lean more about flutter flavors
#  Read https://docs.flutter.dev/deployment/flavors
#  Read https://codewithandrea.com/articles/flutter-flavors-for-firebase-apps/
#  See this https://www.youtube.com/watch?v=Vhm1Cv2uPko&ab_channel=MarcusNg
# 
#  Note we use 6 (3 Android- 3 iOS) app for 3 flavors in 3 Firebase Project


# To build IPA for different flavors with obfuscation and split debug info
build_development_ipa:
	 flutter build ipa --flavor development --target lib/main_development.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.development.json
build_qc_ipa:
	 flutter build ipa --flavor qc --target lib/main_qc.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.qc.json
build_staging_ipa:
	 flutter build ipa --flavor staging --target lib/main_staging.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.staging.json
build_production_ipa:
	 flutter build ipa --flavor production --target lib/main_production.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.production.json


# To build Appbundle for different flavors with obfuscation and split debug info
build_development_appbundle:
	 flutter build appbundle --flavor development --target lib/main_development.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.development.json
build_qc_appbundle:
	 flutter build appbundle --flavor qc --target lib/main_qc.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.qc.json
build_staging_appbundle:
	 flutter build appbundle --flavor staging --target lib/main_staging.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.staging.json
build_production_appbundle:
	 flutter build appbundle --flavor production --target lib/main_production.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.production


# To build APKs for different flavors with obfuscation and split debug info
build_development_apk:
	 flutter build apk --flavor development --target lib/main_development.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.development.json
build_qc_apk:
	 flutter build apk --flavor qc --target lib/main_qc.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.qc.json
build_staging_apk:
	 flutter build apk --flavor staging --target lib/main_staging.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.staging.json
build_production_apk:
	 flutter build apk --flavor production --target lib/main_production.dart --release --obfuscate --split-debug-info=./debug_info --dart-define-from-file=config/config.production.json

# To update launcher icon
update_launcher_icon:
	dart run flutter_launcher_icons:generate

#  Make Firebase config with FlutterFire
configure_firebase_development:
	 flutterfire configure  --project=app_health-dev --out=lib/development_firebase_options.dart --android-app-id= xyz.bs.app_health.dev --ios-bundle-id= xyz.bs.app_health.dev
configure_firebase_qc:
	 flutterfire configure --project=app_health-qc --out=lib/qc_firebase_options.dart --android-app-id= xyz.bs.app_health.qc --ios-bundle-id= xyz.bs.app_health.qc
configure_firebase_staging:
	 flutterfire configure --project=app_health-staging --out=lib/staging_firebase_options.dart --android-app-id= xyz.bs.app_health.staging --ios-bundle-id= xyz.bs.app_health.staging
configure_firebase_production:
	 flutterfire configure --project=hh-jawaher-unified-platform --out=lib/production_firebase_options.dart --android-app-id= xyz.bs.app_health --ios-bundle-id= xyz.bs.app_health


#  Make keystore files
create_keystore:
	keytool -genkey -v -keystore ./android/msalAppKeyCOM.jks -keyalg RSA -keysize 2048 -validity 10000 -alias msalAppKeyCOM




