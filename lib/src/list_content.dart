import 'package:flutter/widgets.dart';

import 'inner_controller_provider.dart';

class ListContent extends StatelessWidget {
  final List<Widget> children;

  const ListContent({
    @required this.children,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerController = BottomSheetInnerControllerProvider.of(context);

    return StreamBuilder(
      stream: innerController.isScrollLockedStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final isScrollLocked = snapshot.data;
        return ListView(
          physics: isScrollLocked ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}
