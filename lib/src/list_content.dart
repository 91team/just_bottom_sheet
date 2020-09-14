import 'package:flutter/widgets.dart';

import 'inner_controller_provider.dart';

class ListContent extends StatelessWidget {
  final EdgeInsets padding;
  final List<Widget> children;

  const ListContent({
    @required this.padding,
    @required this.children,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerController = BottomSheetInnerControllerProvider.of(context);

    return ListView(
      controller: innerController.scrollController,
      padding: padding,
      children: children,
    );
  }
}
