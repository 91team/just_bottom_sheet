import 'package:flutter/widgets.dart';

class ListContent extends StatelessWidget {
  final List<Widget> children;

  const ListContent({
    @required this.children,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
