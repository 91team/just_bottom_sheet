import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/inner_controller.dart';
import 'package:just_bottom_sheet/src/inner_controller_provider.dart';
import 'package:just_bottom_sheet/src/list_content.dart';
import 'package:just_bottom_sheet/src/single_child_content.dart';

import 'list_builder_content.dart';
import 'panel.dart';
import 'sliding_behaviour.dart';

class JustBottomSheet extends StatefulWidget {
  final Widget child;
  final List<Widget> children;
  final Widget Function(BuildContext, int) builder;
  final double minHeight;
  final double maxHeight;
  final List<double> anchors;
  final Function(double value) onSlide;
  final Function(int anchorIndex) onSnap;
  final BoxDecoration panelDecoration;
  final bool isDraggable;
  final JustBottomSheetController controller;
  final int initialAnchorIndex;

  const JustBottomSheet.singleChild({
    @required this.child,
    @required this.minHeight,
    @required this.maxHeight,
    this.isDraggable = true,
    this.controller,
    this.anchors = const [0.0, 1.0],
    this.initialAnchorIndex = 0,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    Key key,
  })  : children = null,
        builder = null,
        super(key: key);

  const JustBottomSheet.listBuilder({
    @required this.builder,
    @required this.minHeight,
    @required this.maxHeight,
    this.isDraggable = true,
    this.controller,
    this.anchors = const [0.0, 1.0],
    this.initialAnchorIndex = 0,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    Key key,
  })  : children = null,
        child = null,
        super(key: key);

  const JustBottomSheet.list({
    @required this.children,
    @required this.minHeight,
    @required this.maxHeight,
    this.isDraggable = true,
    this.controller,
    this.anchors = const [0.0, 1.0],
    this.initialAnchorIndex = 0,
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
  BottomSheetInnerController innerController;
  SlidingBehaviourController slidingBehaviourController;

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller._attach(this);
    }

    innerController = BottomSheetInnerController();
    slidingBehaviourController = SlidingBehaviourController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: BottomSheetInnerControllerProvider(
        controller: innerController,
        child: SlidingBehaviour(
          minHeight: widget.minHeight,
          maxHeight: widget.maxHeight,
          anchors: widget.anchors,
          onSlide: widget.onSlide,
          onSnap: widget.onSnap,
          isDraggable: widget.isDraggable,
          initialAnchorIndex: widget.initialAnchorIndex,
          controller: slidingBehaviourController,
          child: Panel(
            height: widget.maxHeight,
            decoration: widget.panelDecoration,
            child: _selectChild(),
          ),
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

    if (widget.builder != null) {
      return ListBuilderContent(itemBuilder: widget.builder);
    }

    throw Exception('No child, children or builder provided. Check _selectChild in _JustBottomSheetState');
  }

  bool get _isSliding => slidingBehaviourController.isSliding;
  double get _currentBottomSheetPosition => slidingBehaviourController.currentBottomSheetPosition;

  void _snapTo(int snapPointIndex) {
    slidingBehaviourController.snapTo(snapPointIndex);
  }
}

class JustBottomSheetController {
  _JustBottomSheetState bottomSheet;

  bool get isSliding => bottomSheet._isSliding;
  double get currentBottomSheetPosition => bottomSheet._currentBottomSheetPosition;

  void snapTo(int snapPointIndex) {
    bottomSheet._snapTo(snapPointIndex);
  }

  void _attach(_JustBottomSheetState bs) {
    bottomSheet = bs;
  }
}
