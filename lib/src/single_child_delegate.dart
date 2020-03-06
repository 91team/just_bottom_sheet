import 'package:flutter/widgets.dart';

class SingleChildDelegate extends StatelessWidget {
  final Widget child;

  const SingleChildDelegate({
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
