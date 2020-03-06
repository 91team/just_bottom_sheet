import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/list_content.dart';
import 'package:just_bottom_sheet/src/single_child_content.dart';

import 'panel.dart';
import 'sliding_behaviour.dart';

class JustBottomSheet extends StatefulWidget {
  final Widget child;
  final List<Widget> children;
  final Widget Function(BuildContext) builder;
  final double minHeight;
  final double maxHeight;
  final List<double> anchors;
  final Function(double value) onSlide;
  final Function(int anchorIndex) onSnap;
  final BoxDecoration panelDecoration;

  JustBottomSheet.singleChild({
    @required this.child,
    @required this.minHeight,
    @required this.maxHeight,
    this.anchors,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    Key key,
  })  : children = null,
        builder = null,
        super(key: key);

  JustBottomSheet.listBuilder({
    @required this.builder,
    @required this.minHeight,
    @required this.maxHeight,
    this.anchors,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    Key key,
  })  : children = null,
        child = null,
        super(key: key);

  JustBottomSheet.list({
    @required this.children,
    @required this.minHeight,
    @required this.maxHeight,
    this.anchors,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    Key key,
  })  : builder = null,
        child = null,
        super(key: key);

  @override
  _JustBottomSheetState createState() => _JustBottomSheetState();
}

class _JustBottomSheetState extends State<JustBottomSheet> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: SlidingBehaviour(
        minHeight: widget.minHeight,
        maxHeight: widget.maxHeight,
        anchors: widget.anchors,
        onSlide: widget.onSlide,
        onSnap: widget.onSnap,
        child: Panel(
          height: widget.maxHeight,
          decoration: widget.panelDecoration,
          child: _selectChild(),
        ),
      ),
    );
  }

  Widget _selectChild() {
    if (widget.child != null) {
      return SingleChildContent(child: widget.child);
    }

    if (widget.children != null) {
      return ListContent(children: widget.children);
    }

    throw Exception("No child, children or builder provided. Check _selectChild in _JustBottomSheetState");
  }
}
