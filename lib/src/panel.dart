import 'package:flutter/widgets.dart';

class Panel extends StatelessWidget {
  final Widget child;

  final BoxDecoration decoration;

  final double height;

  const Panel({
    required this.child,
    required this.height,
    required this.decoration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: decoration,
        child: child,
      ),
    );
  }
}
