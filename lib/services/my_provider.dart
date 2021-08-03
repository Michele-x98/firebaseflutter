import 'package:flutter/foundation.dart';

class MyProvider with ChangeNotifier {
  bool _inAsync = false;

  bool get inAsync => _inAsync;

  void setInAsync(bool flag) {
    this._inAsync = flag;
    notifyListeners();
  }
}
