import 'package:flutter/widgets.dart';
import 'package:just_bottom_sheet/src/inner_controller.dart';
import 'package:just_bottom_sheet/src/inner_controller_provider.dart';
import 'package:just_bottom_sheet/src/single_child_content.dart';

import 'custom_builder_content.dart';
import 'panel.dart';
import 'sliding_behavior.dart';

typedef CustomBottomSheetBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
);

class JustBottomSheet extends StatefulWidget {
  final Widget? child;

  final CustomBottomSheetBuilder? builder;

  final double minHeight;

  final double maxHeight;

  final List<double> snapPoints;

  final OnSnapCallback? onSnap;

  final OnSlideCallback? onSlide;

  final BoxDecoration panelDecoration;

  final bool isDraggable;

  final JustBottomSheetController controller;

  final int initialSnapIndex;

  final BorderRadius borderRadius;

  final Clip clipBehavior;

  const JustBottomSheet.singleChild({
    required Widget this.child,
    required this.minHeight,
    required this.maxHeight,
    required this.controller,
    required this.panelDecoration,
    this.borderRadius = BorderRadius.zero,
    this.clipBehavior = Clip.hardEdge,
    this.isDraggable = true,
    this.snapPoints = const [0.0, 1.0],
    this.initialSnapIndex = 0,
    this.onSnap,
    this.onSlide,
    Key? key,
  })  : builder = null,
        super(key: key);

  const JustBottomSheet.custom({
    required CustomBottomSheetBuilder this.builder,
    required this.minHeight,
    required this.maxHeight,
    required this.controller,
    required this.panelDecoration,
    this.borderRadius = BorderRadius.zero,
    this.clipBehavior = Clip.hardEdge,
    this.isDraggable = true,
    this.snapPoints = const [0.0, 1.0],
    this.initialSnapIndex = 0,
    this.onSnap,
    this.onSlide,
    Key? key,
  })  : child = null,
        super(key: key);

  @override
  _JustBottomSheetState createState() => _JustBottomSheetState();
}

class _JustBottomSheetState extends State<JustBottomSheet> with SingleTickerProviderStateMixin {
  final innerController = BottomSheetInnerController();
  final slidingBehaviorController = SlidingBehaviorController();

  @override
  void initState() {
    widget.controller._attach(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetInnerControllerProvider(
      controller: innerController,
      child: SlidingBehavior(
        minHeight: widget.minHeight,
        maxHeight: widget.maxHeight,
        anchors: widget.snapPoints,
        onSlide: widget.onSlide,
        onSnap: widget.onSnap,
        isDraggable: widget.isDraggable,
        initialAnchorIndex: widget.initialSnapIndex,
        controller: slidingBehaviorController,
        child: Panel(
          height: widget.maxHeight,
          decoration: widget.panelDecoration,
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            clipBehavior: widget.clipBehavior,
            child: _selectChild(),
          ),
        ),
      ),
    );
  }

  Widget _selectChild() {
    if (widget.child != null) {
      return SingleChildContent(
        child: widget.child!,
      );
    }

    if (widget.builder != null) {
      return CustomBuilderContent(
        builder: widget.builder!,
      );
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
  late _JustBottomSheetState bottomSheet;

  bool get isSliding => bottomSheet._isSliding;
  double get currentBottomSheetPosition => bottomSheet._currentBottomSheetPosition;

  void snapTo(int snapPointIndex) {
    bottomSheet._snapTo(snapPointIndex);
  }

  void _attach(_JustBottomSheetState bs) {
    bottomSheet = bs;
  }
}
