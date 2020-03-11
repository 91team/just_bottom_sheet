import 'package:flutter/widgets.dart';

import 'inner_controller_provider.dart';

class ListBuilderContent extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;

  const ListBuilderContent({
    @required this.itemBuilder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerController = BottomSheetInnerControllerProvider.of(context);

    return ListView.builder(
      controller: innerController.scrollController,
      itemBuilder: itemBuilder,
    );
  }
}
