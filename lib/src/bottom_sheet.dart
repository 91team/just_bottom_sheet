import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/inner_controller.dart';
import 'package:just_bottom_sheet/src/inner_controller_provider.dart';
import 'package:just_bottom_sheet/src/list_content.dart';
import 'package:just_bottom_sheet/src/single_child_content.dart';

import 'custom_builder_content.dart';
import 'list_builder_content.dart';
import 'panel.dart';
import 'sliding_behavior.dart';

class JustBottomSheet extends StatefulWidget {
  final Widget child;
  final List<Widget> children;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, ScrollController) builder;
  final double minHeight;
  final double maxHeight;
  final EdgeInsets padding;
  final List<double> anchors;
  final void Function(double value) onSlide;
  final void Function(int anchorIndex) onSnap;
  final BoxDecoration panelDecoration;
  final bool isDraggable;
  final JustBottomSheetController controller;
  final int initialAnchorIndex;
  final bool wrapPositioned;

  const JustBottomSheet.singleChild({
    @required this.child,
    @required this.minHeight,
    @required this.maxHeight,
    this.isDraggable = true,
    this.controller,
    this.anchors = const [0.0, 1.0],
    this.initialAnchorIndex = 0,
    this.wrapPositioned = true,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    this.padding,
    Key key,
  })  : assert(child != null),
        children = null,
        itemBuilder = null,
        builder = null,
        super(key: key);

  const JustBottomSheet.listBuilder({
    @required this.itemBuilder,
    @required this.minHeight,
    @required this.maxHeight,
    this.isDraggable = true,
    this.controller,
    this.anchors = const [0.0, 1.0],
    this.initialAnchorIndex = 0,
    this.wrapPositioned = true,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    this.padding,
    Key key,
  })  : assert(itemBuilder != null),
        children = null,
        child = null,
        builder = null,
        super(key: key);

  const JustBottomSheet.list({
    @required this.children,
    @required this.minHeight,
    @required this.maxHeight,
    this.isDraggable = true,
    this.controller,
    this.anchors = const [0.0, 1.0],
    this.initialAnchorIndex = 0,
    this.wrapPositioned = true,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    this.padding,
    Key key,
  })  : assert(children != null),
        itemBuilder = null,
        child = null,
        builder = null,
        super(key: key);

  const JustBottomSheet.custom({
    @required this.builder,
    @required this.minHeight,
    @required this.maxHeight,
    this.isDraggable = true,
    this.controller,
    this.anchors = const [0.0, 1.0],
    this.initialAnchorIndex = 0,
    this.wrapPositioned = true,
    this.onSlide,
    this.onSnap,
    this.panelDecoration,
    Key key,
  })  : assert(builder != null),
        itemBuilder = null,
        child = null,
        children = null,
        padding = null,
        super(key: key);

  @override
  _JustBottomSheetState createState() => _JustBottomSheetState();
}

class _JustBottomSheetState extends State<JustBottomSheet> with SingleTickerProviderStateMixin {
  BottomSheetInnerController innerController;
  SlidingBehaviorController slidingBehaviorController;

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller._attach(this);
    }

    innerController = BottomSheetInnerController();
    slidingBehaviorController = SlidingBehaviorController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheet = BottomSheetInnerControllerProvider(
      controller: innerController,
      child: SlidingBehavior(
        minHeight: widget.minHeight,
        maxHeight: widget.maxHeight,
        anchors: widget.anchors,
        onSlide: widget.onSlide,
        onSnap: widget.onSnap,
        isDraggable: widget.isDraggable,
        initialAnchorIndex: widget.initialAnchorIndex,
        controller: slidingBehaviorController,
        child: Panel(
          height: widget.maxHeight,
          decoration: widget.panelDecoration,
          child: _selectChild(),
        ),
      ),
    );

    if (widget.wrapPositioned) {
      return Positioned(
        child: bottomSheet,
        bottom: 0,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      return bottomSheet;
    }
  }

  Widget _selectChild() {
    if (widget.child != null) {
      return SingleChildContent(child: widget.child, padding: widget.padding);
    }

    if (widget.children != null) {
      return ListContent(children: widget.children, padding: widget.padding);
    }

    if (widget.itemBuilder != null) {
      return ListBuilderContent(itemBuilder: widget.itemBuilder, padding: widget.padding);
    }

    if (widget.builder != null) {
      return CustomBuilderContent(builder: widget.builder);
    }

    throw Exception('JustBottomSheet: No child, children or builders provided');
  }

  bool get _isSliding => slidingBehaviorController.isSliding;
  double get _currentBottomSheetPosition => slidingBehaviorController.currentBottomSheetPosition;

  void _snapTo(int snapPointIndex) {
    slidingBehaviorController.snapTo(snapPointIndex);
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
