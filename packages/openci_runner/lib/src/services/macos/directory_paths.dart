const certificateDirectory = '~/Downloads/certificates';
const keychainPath = '$certificateDirectory/app-signing.keychain-db';
const p12 = '$certificateDirectory/build_certificate.p12';
const mobileprovisionPath = '$certificateDirectory/build_pp.mobileprovision';

String ipaBuildPath(String appName, String appNameOfPubspecYaml) =>
    '/Users/admin/Downloads/$appName/build/ios/ipa/$appNameOfPubspecYaml.ipa';
