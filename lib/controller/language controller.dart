import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LangProvider extends ChangeNotifier {
  void langChanged() {
    notifyListeners();
  }
}

final langController = ChangeNotifierProvider<LangProvider>((ref) {
  return LangProvider();
});
