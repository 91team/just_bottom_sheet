import 'package:flutter/widgets.dart';

import 'inner_controller.dart';

class BottomSheetInnerControllerProvider extends InheritedWidget {
  final BottomSheetInnerController controller;

  const BottomSheetInnerControllerProvider({
    Key key,
    @required this.controller,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static BottomSheetInnerController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BottomSheetInnerControllerProvider>().controller;
  }

  @override
  bool updateShouldNotify(BottomSheetInnerControllerProvider old) => false;
}
