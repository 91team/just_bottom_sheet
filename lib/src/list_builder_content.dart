import 'package:flutter/widgets.dart';

import 'inner_controller_provider.dart';

class ListBuilderContent extends StatelessWidget {
  final EdgeInsets padding;

  final Widget Function(BuildContext, int) itemBuilder;

  final int itemCount;

  const ListBuilderContent({
    required this.padding,
    required this.itemBuilder,
    required this.itemCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerController = BottomSheetInnerControllerProvider.of(context);

    return ListView.builder(
      controller: innerController.scrollController,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      padding: padding,
    );
  }
}
