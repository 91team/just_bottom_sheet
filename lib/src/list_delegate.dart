import 'package:flutter/widgets.dart';

class ListDelegate extends StatelessWidget {
  final Widget child;

  const ListDelegate({
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
