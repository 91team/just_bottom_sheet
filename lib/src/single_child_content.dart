import 'package:flutter/widgets.dart';

class SingleChildContent extends StatelessWidget {
  final Widget child;

  const SingleChildContent({
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: child,
    );
  }
}
