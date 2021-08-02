import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebaseflutter/local_storage.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class BadgeCounterHandler {
  int _currentCount = 0;
  LocalStorage _localstorage = new LocalStorage();

  BadgeCounterHandler() {
    this._setCurrentCount();
  }

  void analyzeAppleNotification(AppleNotification appleNotification) {
    String? badge = appleNotification.badge;
    if (badge != null) {
      _localstorage.write('badge_counter', badge);
    } else {
      incrementAppBadgeCounter();
    }
  }

  void _setCurrentCount() async {
    var count = await _localstorage.read('badge_counter');
    if (count != null) {
      _currentCount = int.parse(count);
    }
  }

  void incrementAppBadgeCounter() {
    FlutterAppBadger.updateBadgeCount(_currentCount + 1);
    _localstorage.write('badge_counter', (_currentCount + 1).toString());
  }

  void decrementAppBadgeCounter() {
    if (_currentCount > 0) {
      FlutterAppBadger.updateBadgeCount(_currentCount - 1);
      _localstorage.write('badge_counter', (_currentCount - 1).toString());
    }
  }

  void removeAppBadgeCounter() {
    FlutterAppBadger.removeBadge();
  }
}
