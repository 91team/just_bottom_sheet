import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/inner_controller_provider.dart';

class SingleChildContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const SingleChildContent({
    @required this.child,
    @required this.padding,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerController = BottomSheetInnerControllerProvider.of(context);

    return SingleChildScrollView(
      controller: innerController.scrollController,
      padding: padding,
      child: child,
    );
  }
}
