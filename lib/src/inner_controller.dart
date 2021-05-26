import 'package:flutter/widgets.dart';

class BottomSheetInnerController {
  bool isContentScrollEnabled = false;

  final scrollController = ScrollController();

  BottomSheetInnerController() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!isContentScrollEnabled) {
      scrollController.jumpTo(0);
    }
  }

  void enableScroll() {
    isContentScrollEnabled = true;
  }

  void disableScroll() {
    isContentScrollEnabled = false;
  }

  void dispose() {
    scrollController.dispose();
  }
}
