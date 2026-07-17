/* import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
 */
/// Central place for API configuration.
///
/// IMPORTANT (local dev only): "localhost" means different things depending
/// on where the app is running:
///   - Android EMULATOR's "localhost" is the emulator itself, NOT your PC.
///     It normally needs 10.0.2.2 to reach your PC's localhost.
///   - A PHYSICAL Android phone over USB has no such alias. Instead, run
///     `adb reverse tcp:5109 tcp:5109` once per USB connection — this makes
///     the phone's own "localhost:5109" forward straight to your PC's
///     localhost:5109 over the cable. That's what we're using here.
///   - iOS simulator / web / Windows desktop can use localhost directly.
///
/// We use plain HTTP on port 5109 for local dev to avoid dealing with the
/// ASP.NET Core self-signed HTTPS dev certificate, which most emulators/
/// simulators/devices don't trust out of the box. Switch to HTTPS once you
/// have a real deployed backend with a real certificate.
///
/// NOTE: if you switch back to testing on the Android EMULATOR instead of
/// a physical device, change the Android line below back to:
///   if (Platform.isAndroid) return 'http://10.0.2.2:$_devPort/api';
class ApiConfig {
  //static const int _devPort = 5109;
  static const String baseUrl = 'https://trova-backend-btbqdhhzeygphjd6.uaenorth-01.azurewebsites.net/api';

  /* 
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:$_devPort/api';

    try {
      // Physical device via USB + `adb reverse` -> localhost works directly.
      if (Platform.isAndroid) return 'http://localhost:$_devPort/api';
      if (Platform.isIOS) return 'http://localhost:$_devPort/api';
    } catch (_) {
      // Platform not available (e.g. some desktop/test contexts) — fall through.
    }

    return 'http://localhost:$_devPort/api';
  }
 */
  // TODO: once the backend is deployed (Azure/Render/etc.), swap baseUrl
  // to the real HTTPS URL here, ideally driven by a build flavor/env flag
  // rather than a hardcoded string.
}
