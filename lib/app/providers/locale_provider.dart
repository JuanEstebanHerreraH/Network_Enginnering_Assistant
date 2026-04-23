/// LocaleProvider
/// Manages the app language (Spanish / English).

import 'package:flutter/foundation.dart';

class LocaleProvider extends ChangeNotifier {
  bool _isSpanish = true; // Default: Spanish

  bool get isSpanish => _isSpanish;
  String get languageLabel => _isSpanish ? 'ES' : 'EN';

  void toggle() {
    _isSpanish = !_isSpanish;
    notifyListeners();
  }

  void setSpanish(bool value) {
    _isSpanish = value;
    notifyListeners();
  }
}
