import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateInfo {
  final Version minSupported;
  final Version latest;
  final Uri storeUri;
  final Uri fallbackWebUri;
  final String? message;

  UpdateInfo({
    required this.minSupported,
    required this.latest,
    required this.storeUri,
    required this.fallbackWebUri,
    this.message,
  });
}

Future<UpdateInfo> fetchUpdateInfo(Uri configUrl) async {
  final res = await http.get(configUrl).timeout(const Duration(seconds: 6));
  if (res.statusCode != 200) throw Exception('config ${res.statusCode}');
  final json = jsonDecode(res.body) as Map<String, dynamic>;

  final store = (json['store'] as Map).cast<String, dynamic>();
  final bool isAndroid = Platform.isAndroid;

  return UpdateInfo(
    minSupported: Version.parse(json['minSupported'] as String),
    latest: Version.parse(json['latest'] as String),
    storeUri: Uri.parse(
      isAndroid ? store['android'] as String : store['ios'] as String,
    ),
    fallbackWebUri: Uri.parse(
      isAndroid ? store['android_web'] as String : store['ios_web'] as String,
    ),
    message: (json['message'] as String?)?.trim(),
  );
}

Future<Version> currentVersion() async {
  final info = await PackageInfo.fromPlatform();
  // Info: info.buildNumber könntest du bei Bedarf in den Vergleich einbeziehen
  return Version.parse(info.version); // z. B. "1.0.0"
}

Future<void> openStore(UpdateInfo ui) async {
  // Versuche Deep Link (market:// / itms-apps://), fallbacks auf Web
  if (await canLaunchUrl(ui.storeUri)) {
    await launchUrl(ui.storeUri, mode: LaunchMode.externalApplication);
  } else {
    await launchUrl(ui.fallbackWebUri, mode: LaunchMode.externalApplication);
  }
}
