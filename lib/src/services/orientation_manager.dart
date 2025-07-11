// --- Orientation Management ---

import 'package:flutter/services.dart';

class OrientationManager {
  static const List<DeviceOrientation> _allOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  static const List<DeviceOrientation> _landscapeOnly = [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  static Future<void> unlockOrientation() async {
    try {
      await SystemChrome.setPreferredOrientations(_allOrientations);
    } catch (e) {
      print('Error unlocking orientation: $e');
    }
  }

  static Future<void> lockToLandscape() async {
    try {
      await SystemChrome.setPreferredOrientations(_landscapeOnly);
    } catch (e) {
      print('Error locking to landscape: $e');
    }
  }
}
