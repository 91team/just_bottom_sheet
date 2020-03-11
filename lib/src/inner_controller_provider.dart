import 'package:flutter/widgets.dart';

import 'inner_controller.dart';

class BottomSheetInnerControllerProvider extends InheritedWidget {
  final BottomSheetInnerController controller;

  const BottomSheetInnerControllerProvider({
    @required this.controller,
    @required Widget child,
    Key key,
  })  : assert(child != null),
        super(key: key, child: child);

  static BottomSheetInnerController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BottomSheetInnerControllerProvider>().controller;
  }

  @override
  bool updateShouldNotify(BottomSheetInnerControllerProvider oldWidget) => false;
}
