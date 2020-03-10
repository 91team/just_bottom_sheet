import 'package:flutter/widgets.dart';

class BottomSheetInnerController {
  bool isScrollEnabled = false;

  ScrollController scrollController = ScrollController();

  BottomSheetInnerController() {
    scrollController.addListener(_onScroll);
  }

  bool get isScrollDisabled => !isScrollEnabled;
  bool get isDraggingLocked => isScrollEnabled;

  _onScroll() {
    if (isScrollDisabled) {
      scrollController.jumpTo(0);
    }
  }

  void enableScroll() {
    isScrollEnabled = true;
  }

  void disableScroll() {
    isScrollEnabled = false;
  }

  void dispose() {
    scrollController.dispose();
  }
}
