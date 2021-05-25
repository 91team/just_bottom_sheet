import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/inner_controller_provider.dart';

class SingleChildContent extends StatelessWidget {
  final Widget child;

  const SingleChildContent({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerController = BottomSheetInnerControllerProvider.of(context);

    return SingleChildScrollView(
      controller: innerController.scrollController,
      padding: EdgeInsets.zero,
      child: child,
    );
  }
}
