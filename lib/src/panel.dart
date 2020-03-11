import 'package:flutter/widgets.dart';

class Panel extends StatelessWidget {
  final Widget child;
  final BoxDecoration decoration;
  final double height;

  const Panel({
    @required this.child,
    @required this.height,
    this.decoration,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: decoration ?? const BoxDecoration(color: Color(0xFFFFFFFF)),
        child: child,
      ),
    );
  }
}
