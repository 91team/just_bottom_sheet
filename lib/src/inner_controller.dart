import 'dart:async';

class BottomSheetInnerController {
  StreamController<bool> isScrollLockedStreamController = StreamController();

  Stream<bool> get isScrollLockedStream => isScrollLockedStreamController.stream;

  void lock() {
    isScrollLockedStreamController.add(true);
  }

  void unlock() {
    isScrollLockedStreamController.add(false);
  }

  void dispose() {
    isScrollLockedStreamController.close();
  }
}
