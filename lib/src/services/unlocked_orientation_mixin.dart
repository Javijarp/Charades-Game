// Mixin for screens that need to ensure unlocked orientation
import 'package:flutter/material.dart';
import 'package:what/src/services/orientation_manager.dart';

mixin UnlockedOrientationMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    // Ensure orientation is unlocked when this screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrientationManager.unlockOrientation();
    });
  }
}
