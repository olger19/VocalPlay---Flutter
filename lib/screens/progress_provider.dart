import 'package:flutter/foundation.dart';

class ProgressProvider with ChangeNotifier {
  double _progress = 0.0;

  double get progress => _progress;

  void updateProgress(double value) {
    _progress = value;
    notifyListeners(); // Notifica a los widgets que dependen de este estado
  }

  void resetProgress() {
    _progress = 0.0;
    notifyListeners();
  }
}
