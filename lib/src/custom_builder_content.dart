import 'package:flutter/widgets.dart';

import 'inner_controller_provider.dart';

class CustomBuilderContent extends StatelessWidget {
  final Widget Function(BuildContext, ScrollController) builder;

  const CustomBuilderContent({
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerController = BottomSheetInnerControllerProvider.of(context);

    return builder(context, innerController.scrollController);
  }
}
