import 'package:flutter/material.dart';

class Providers extends ChangeNotifier {
  bool isSwitched;

  Providers({
    this.isSwitched = false,
  });

  void onOFF({
    required bool isSwitching,
  }) {
    isSwitched = isSwitching;
    notifyListeners();
  }
}
