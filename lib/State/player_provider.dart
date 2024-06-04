import 'package:flutter/foundation.dart';

class MatchProvider with ChangeNotifier {
  List<String> activeTerang = [];
  List<String> activeGelap = [];

  void updateActiveTerang(List<String> players) {
    activeTerang = players;
    notifyListeners();
  }

  void updateActiveGelap(List<String> players) {
    activeGelap = players;
    notifyListeners();
  }

  bool isTerangActive(String angka) {
    return activeTerang.contains(angka);
  }

  bool isGelapActive(String angka) {
    return activeGelap.contains(angka);
  }

  void resetPlayer(){
    activeGelap.clear();
    activeTerang.clear();

    notifyListeners();
  }
}
