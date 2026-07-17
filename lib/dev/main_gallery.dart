import 'package:flutter/material.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/core/theme.dart';
import 'package:trova/dev/screens_gallery.dart';

// DEV-ONLY entry point. Doesn't touch or replace your real lib/main.dart.
// Run with:
//   flutter run -t lib/dev/main_gallery.dart
//
// Boots straight into a tappable list of every new screen, each pre-filled
// with dummy data, so you can eyeball them without walking through real
// signup / forgot-password flows every time. Backend calls inside these
// screens will still fail (endpoints don't exist yet on TrovaBackend) —
// that's expected, you're just checking the UI here.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trova — Screens Gallery',
      theme: AppTheme.lightTheme,
      home: const ScreensGallery(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
